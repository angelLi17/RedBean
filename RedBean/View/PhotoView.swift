//
//  PhotoView.swift
//  RedBean
//
//  Created by Angel on 5/24/25.
//

import SwiftUI
import StreamVideo
import StreamVideoSwiftUI

/// The photobooth after End Bean: a shared 3-2-1 countdown takes four shots of both friends,
/// then they're placed into the RedBean photo strip.
struct PhotoView: View {
    @ObservedObject var callModel: CallViewModel

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height

    @State private var savedToPhotos = false

    var body: some View {
        ZStack {
            Image("Bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .frame(width: screenWidth, height: screenHeight)
                .opacity(0.3)

            VStack(spacing: screenHeight / 40) {
                headerView
                if let strip = callModel.boothStrip {
                    resultView(strip)
                } else {
                    boothView
                }
            }
        }
    }

    var headerView: some View {
        Text("Bean Booth")
            .font(.custom("Jua", size: 30))
            .foregroundColor(Color("aRed"))
            .frame(width: screenWidth, height: screenHeight / 20)
            .background {
                Color("aPink")
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.30), radius: 2, y: 4)
            }
    }

    // MARK: - Taking photos

    var boothView: some View {
        VStack(spacing: screenHeight / 40) {
            let previewWidth = 9 * screenWidth / 11
            ZStack {
                livePreview
                    .snapshot(trigger: callModel.boothTrigger) { image in
                        Task { @MainActor in callModel.addBoothShot(image) }
                    }
                countdownOverlay
            }
            .frame(width: previewWidth, height: previewWidth / PhotoStrip.shotAspectRatio)
            .cornerRadius(10)
            .padding(10)
            .background(Color("aPink").cornerRadius(20))

            Text(boothHint)
                .font(.custom("Biryani", size: 16))
                .foregroundColor(Color("aRed"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            Spacer()

            HStack(spacing: screenWidth / 22) {
                footerButton("start", enabled: !callModel.boothRunning && callModel.call != nil) {
                    callModel.startPhotobooth()
                }
                footerButton("skip", enabled: !callModel.boothRunning, filled: false) {
                    callModel.finishBean()
                }
            }
            .padding(.bottom, screenHeight / 20)
        }
    }

    private var boothHint: String {
        if callModel.call == nil {
            return "the call has ended, so there's no one to photograph"
        }
        if callModel.boothRunning {
            return "shot \(min(callModel.boothShots.count + 1, PhotoStrip.shotCount)) of \(PhotoStrip.shotCount)"
        }
        return "great bean! tap start and strike 4 poses with \(callModel.friendName)"
    }

    /// The two friends side by side, in the same order on both phones (sorted by user id),
    /// so both people get the same strip.
    var livePreview: some View {
        GeometryReader { geo in
            let people = [callModel.localParticipant, callModel.remoteParticipant]
                .compactMap { $0 }
                .sorted { $0.userId < $1.userId }
            let tile = CGSize(width: geo.size.width / CGFloat(max(people.count, 1)), height: geo.size.height)
            HStack(spacing: 0) {
                ForEach(people, id: \.id) { person in
                    VideoCallParticipantView(
                        viewFactory: DefaultViewFactory.shared,
                        participant: person,
                        id: "\(person.id)-booth",
                        availableFrame: CGRect(origin: .zero, size: tile),
                        contentMode: .scaleAspectFill,
                        customData: person.id == callModel.localParticipant?.id
                            ? ["videoOn": .bool(callModel.cameraOn)] : [:],
                        call: callModel.call
                    )
                    .frame(width: tile.width, height: tile.height)
                    .clipped()
                }
            }
        }
        .background(Color.white)
    }

    @ViewBuilder
    var countdownOverlay: some View {
        if let count = callModel.boothCountdown {
            if count > 0 {
                Text("\(count)")
                    .font(.custom("Jua", size: 90))
                    .foregroundColor(.white)
                    .shadow(radius: 6)
            } else {
                Color.white.opacity(0.8) // flash
            }
        }
    }

    // MARK: - Result

    func resultView(_ strip: UIImage) -> some View {
        VStack(spacing: screenHeight / 40) {
            Image(uiImage: strip)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: screenHeight * 0.62)
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 4, y: 4)

            HStack(spacing: screenWidth / 30) {
                footerButton(savedToPhotos ? "saved!" : "save", enabled: !savedToPhotos) {
                    UIImageWriteToSavedPhotosAlbum(strip, nil, nil, nil)
                    savedToPhotos = true
                }
                ShareLink(
                    item: Image(uiImage: strip),
                    preview: SharePreview("RedBean photo strip", image: Image(uiImage: strip))
                ) {
                    footerLabel("share", filled: true)
                }
            }

            HStack(spacing: screenWidth / 30) {
                footerButton("retake", enabled: callModel.call != nil, filled: false) {
                    savedToPhotos = false
                    callModel.retakePhotobooth()
                }
                footerButton("done", enabled: true, filled: false) {
                    callModel.finishBean()
                }
            }
        }
    }

    // MARK: - Buttons

    private func footerButton(_ title: String, enabled: Bool, filled: Bool = true, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            footerLabel(title, filled: filled)
        }
        .disabled(!enabled)
        .opacity(enabled ? 1 : 0.5)
    }

    private func footerLabel(_ title: String, filled: Bool) -> some View {
        Text(title)
            .font(.custom("Biryani", size: 20))
            .foregroundColor(filled ? .white : Color("aRed"))
            .frame(width: 2 * screenWidth / 7, height: screenHeight / 22)
            .background(filled ? Color("aRed") : Color("aPink"))
            .cornerRadius(10)
    }
}

#Preview {
    PhotoView(callModel: CallViewModel())
}
