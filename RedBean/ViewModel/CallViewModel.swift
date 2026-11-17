//
//  CallViewModel.swift
//  RedBean
//
//  Created by Angel on 5/18/25.
//

import SwiftUI
import Foundation
import Combine
import CryptoKit
import FirebaseAuth
import FirebaseCore
import StreamVideo
import StreamVideoSwiftUI

enum CallStatus: Equatable {
    case idle
    case connecting
    case waitingForFriend
    case inCall
    case failed(String)
}

@MainActor
class CallViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var nextScreen: AppScreen = .call //not connected to homeview's screen variable

    /// The signed-in user. ContentView sets this before showing the call screen.
    var currentUser: AppUser?

    let builtInSchedules = [
        TimerSchedule(name: "Classic Pomodoro", workMinutes: 25, breakMinutes: 5),
        TimerSchedule(name: "Short Focus", workMinutes: 20, breakMinutes: 10),
        TimerSchedule(name: "Deep Work", workMinutes: 50, breakMinutes: 10)
    ]

    let builtInTimes = [
        "5",
        "10",
        "15",
        "20",
        "25",
        "30",
        "45",
        "55",
        "Other",
    ]

    @Published var customTime: String = ""
    @Published var otherTime: String = ""

    // MARK: - Video call state

    @Published var callStatus: CallStatus = .idle
    @Published var localParticipant: CallParticipant?
    @Published var remoteParticipant: CallParticipant?
    @Published var micOn = true
    @Published var cameraOn = true

    private(set) var call: Call?
    private var streamVideo: StreamVideo?
    private var streamVideoUI: StreamVideoUI? // keeps the SDK's UI appearance set up
    private var cancellables = Set<AnyCancellable>()

    /// Both friends land in the same call because the call id is derived from their two user ids,
    /// sorted so it's identical no matter who taps START first.
    static func callID(_ uidA: String, _ uidB: String) -> String {
        let pair = [uidA, uidB].sorted().joined(separator: "|")
        let digest = SHA256.hash(data: Data(pair.utf8))
        let hex = digest.map { String(format: "%02x", $0) }.joined()
        return "bean_" + hex.prefix(32)
    }

    /// Joins (creating if needed) the shared call with a friend.
    func startBean(friendUID: String) async {
        guard call == nil else { return }
        guard let me = currentUser else {
            callStatus = .failed("You're not signed in.")
            return
        }
        callStatus = .connecting
        do {
            let client = try await connectedClient(for: me)
            let call = client.call(callType: StreamConfig.callType, callId: Self.callID(me.id, friendUID))
            self.call = call
            observe(call)
            _ = try await call.join(
                create: true,
                options: CreateCallOptions(memberIds: [me.id, friendUID])
            )
            callStatus = remoteParticipant == nil ? .waitingForFriend : .inCall
        } catch {
            leaveCall()
            callStatus = .failed(error.localizedDescription)
        }
    }

    /// Leaves the call. Safe to call more than once.
    func leaveCall() {
        call?.leave()
        call = nil
        cancellables.removeAll()
        localParticipant = nil
        remoteParticipant = nil
        callStatus = .idle
    }

    func endBean() {
        leaveCall()
        nextScreen = .photo
    }

    func toggleMic() {
        Task { try? await call?.microphone.toggle() }
    }

    func toggleCamera() {
        Task { try? await call?.camera.toggle() }
    }

    func flipCamera() {
        Task { try? await call?.camera.flip() }
    }

    // MARK: - Private

    private func observe(_ call: Call) {
        call.state.$remoteParticipants
            .receive(on: DispatchQueue.main)
            .sink { [weak self] participants in
                guard let self else { return }
                self.remoteParticipant = participants.first
                switch self.callStatus {
                case .waitingForFriend where participants.first != nil:
                    self.callStatus = .inCall
                case .inCall where participants.first == nil:
                    self.callStatus = .waitingForFriend
                default:
                    break
                }
            }
            .store(in: &cancellables)

        call.state.$localParticipant
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.localParticipant = $0 }
            .store(in: &cancellables)

        call.state.$callSettings
            .receive(on: DispatchQueue.main)
            .sink { [weak self] settings in
                self?.micOn = settings.audioOn
                self?.cameraOn = settings.videoOn
            }
            .store(in: &cancellables)
    }

    /// Returns a Stream client connected as `user`, creating one the first time.
    private func connectedClient(for user: AppUser) async throws -> StreamVideo {
        if let existing = streamVideo, existing.user.id == user.id {
            return existing
        }
        if let stale = streamVideo {
            await stale.disconnect()
            streamVideo = nil
        }

        let token = try await StreamTokenService.fetchToken()
        let streamUser = User(
            id: user.id,
            name: user.name,
            imageURL: user.imageURL.flatMap(URL.init(string:))
        )
        let client = StreamVideo(
            apiKey: StreamConfig.apiKey,
            user: streamUser,
            token: UserToken(rawValue: token),
            tokenProvider: { result in
                // Called by the SDK when the token expires.
                Task {
                    do {
                        result(.success(UserToken(rawValue: try await StreamTokenService.fetchToken())))
                    } catch {
                        result(.failure(error))
                    }
                }
            }
        )
        streamVideoUI = StreamVideoUI(streamVideo: client)
        try await client.connect()
        streamVideo = client
        return client
    }
}

/// Fetches a Stream user token from the getStreamToken Cloud Function.
/// Speaks the Firebase callable protocol directly so the app doesn't need the FirebaseFunctions package.
enum StreamTokenService {
    struct TokenError: LocalizedError {
        let errorDescription: String?
    }

    static func fetchToken() async throws -> String {
        guard let user = Auth.auth().currentUser else {
            throw TokenError(errorDescription: "You're not signed in.")
        }
        guard
            let projectID = FirebaseApp.app()?.options.projectID,
            let url = URL(string: "https://\(StreamConfig.functionsRegion)-\(projectID).cloudfunctions.net/getStreamToken")
        else {
            throw TokenError(errorDescription: "Firebase isn't configured.")
        }

        let idToken = try await user.getIDToken()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONSerialization.data(withJSONObject: ["data": [String: String]()])

        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        if let result = json?["result"] as? [String: Any], let token = result["token"] as? String {
            return token
        }
        let message = (json?["error"] as? [String: Any])?["message"] as? String
        throw TokenError(errorDescription: message ?? "Couldn't get a call token from the server.")
    }
}
