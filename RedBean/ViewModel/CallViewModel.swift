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
import AudioToolbox
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

struct ChecklistProgress: Equatable {
    var done: Int
    var total: Int
}

@MainActor
class CallViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var nextScreen: AppScreen = .call //not connected to homeview's screen variable

    /// The signed-in user. ContentView sets this after login.
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

    // MARK: - Who we're beaning with

    @Published var friendUID: String?
    @Published var friendName: String = "your friend"

    // MARK: - Video call state

    @Published var callStatus: CallStatus = .idle
    @Published var localParticipant: CallParticipant?
    @Published var remoteParticipant: CallParticipant?
    @Published var micOn = true
    @Published var cameraOn = true
    /// Flips each time a ringing call is answered from the iPhone call screen, so ContentView can show it.
    @Published var answeredIncomingCall = 0

    // MARK: - Shared timer and checklist

    @Published var timer = SharedTimer(workMinutes: 25, breakMinutes: 5)
    @Published var now = Date()
    @Published var checklist: [ChecklistItem] = [] {
        didSet { sendChecklistProgress() }
    }
    @Published var friendProgress: ChecklistProgress?

    // MARK: - Photobooth

    @Published var boothCountdown: Int?
    @Published var boothRunning = false
    @Published var boothStrip: UIImage?
    private(set) var boothShots: [UIImage] = []
    let boothTrigger = BoothSnapshotTrigger()

    private(set) var call: Call?
    private var streamVideo: StreamVideo?
    private var streamVideoUI: StreamVideoUI? // keeps the SDK's UI appearance set up
    private var callCancellables = Set<AnyCancellable>()
    private var clientCancellables = Set<AnyCancellable>()
    private var eventsTask: Task<Void, Never>?
    private var boothTask: Task<Void, Never>?
    private var lastSentProgress: ChecklistProgress?
    private var recentlyLeft: (cId: String, at: Date)?

    /// Both friends land in the same call because the call id is derived from their two user ids,
    /// sorted so it's identical no matter who taps START first.
    static func callID(_ uidA: String, _ uidB: String) -> String {
        let pair = [uidA, uidB].sorted().joined(separator: "|")
        let digest = SHA256.hash(data: Data(pair.utf8))
        let hex = digest.map { String(format: "%02x", $0) }.joined()
        return "bean_" + hex.prefix(32)
    }

    // MARK: - Connecting

    /// Connects to Stream right after login, so incoming rings can arrive while on the home screen.
    func connect() async {
        guard let me = currentUser else { return }
        do {
            _ = try await connectedClient(for: me)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// Resets per-bean state before the call screen opens (START on the Start a Bean screen).
    func prepareBean(friendUID: String, friendName: String, schedule: TimerSchedule) {
        self.friendUID = friendUID
        self.friendName = friendName
        timer = SharedTimer(schedule: schedule)
        resetSessionState()
        nextScreen = .call
    }

    /// Joins (creating if needed) the shared call with the friend, and rings them if they aren't there yet.
    func startBean() async {
        guard call == nil else { return }
        guard let me = currentUser, let friendUID else {
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
            if remoteParticipant == nil {
                callStatus = .waitingForFriend
                // Rings their phone. Does nothing useful until push notifications are set up.
                _ = try? await call.ring()
            } else {
                callStatus = .inCall
            }
        } catch {
            leaveCall()
            callStatus = .failed(error.localizedDescription)
        }
    }

    /// Leaves the call. Safe to call more than once.
    func leaveCall() {
        if let call {
            // The SDK may briefly still report this as the active call; don't mistake it for an answered ring.
            recentlyLeft = (call.cId, Date())
        }
        call?.leave()
        call = nil
        eventsTask?.cancel()
        eventsTask = nil
        boothTask?.cancel()
        boothTask = nil
        callCancellables.removeAll()
        localParticipant = nil
        remoteParticipant = nil
        callStatus = .idle
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

    // MARK: - Timer

    /// Called every second by the call screen.
    func tick() {
        now = Date()
        if timer.advance(to: now) {
            AudioServicesPlaySystemSound(1005) // chime when a work/break block ends
        }
    }

    func toggleTimer() {
        if timer.isRunning {
            timer.pause(at: Date())
        } else {
            timer.start(at: Date())
        }
        send(.timer(timer))
    }

    /// Applies the custom block picker. Returns false if no valid time is chosen yet.
    @discardableResult
    func setCustomTimer(isWork: Bool) -> Bool {
        let text = customTime == "Other" ? otherTime : customTime
        guard let minutes = Int(text.filter(\.isNumber)), minutes > 0 else { return false }
        timer.setCustom(minutes: minutes, isWork: isWork, at: Date())
        send(.timer(timer))
        return true
    }

    // MARK: - Photobooth

    /// End Bean: both friends head to the photobooth. The call stays connected until they're done.
    func endBean() {
        if call != nil {
            send(.photoboothOpen)
        }
        nextScreen = .photo
    }

    /// Starts a shared countdown on both phones.
    func startPhotobooth() {
        let startAt = Date().addingTimeInterval(1.5)
        send(.photoboothStart(at: startAt))
        runPhotobooth(startingAt: startAt)
    }

    func addBoothShot(_ image: UIImage) {
        guard boothRunning, boothShots.count < PhotoStrip.shotCount else { return }
        boothShots.append(image)
    }

    func retakePhotobooth() {
        boothStrip = nil
        boothShots = []
    }

    /// Leaves the call and returns home.
    func finishBean() {
        leaveCall()
        resetSessionState()
        nextScreen = .home
    }

    private func runPhotobooth(startingAt startAt: Date) {
        guard !boothRunning else { return }
        boothRunning = true
        boothShots = []
        boothStrip = nil
        boothTask = Task { [weak self] in
            let wait = startAt.timeIntervalSinceNow
            if wait > 0 { try? await Task.sleep(for: .seconds(wait)) }

            for _ in 0..<PhotoStrip.shotCount {
                for count in [3, 2, 1] {
                    self?.boothCountdown = count
                    try? await Task.sleep(for: .seconds(1))
                }
                self?.boothCountdown = 0 // flash
                self?.boothTrigger.capture()
                try? await Task.sleep(for: .seconds(0.7))
            }
            self?.boothCountdown = nil

            // Give the last snapshot a moment to arrive.
            for _ in 0..<20 where (self?.boothShots.count ?? 0) < PhotoStrip.shotCount {
                try? await Task.sleep(for: .seconds(0.1))
            }
            guard let self, !Task.isCancelled else { return }
            self.boothStrip = PhotoStrip.makeStrip(shots: self.boothShots)
            self.boothRunning = false
        }
    }

    private func resetSessionState() {
        checklist = []
        friendProgress = nil
        lastSentProgress = nil
        boothTask?.cancel()
        boothTask = nil
        boothRunning = false
        boothCountdown = nil
        boothShots = []
        boothStrip = nil
        customTime = ""
        otherTime = ""
    }

    // MARK: - Messages between friends

    private func send(_ message: BeanMessage) {
        guard let call else { return }
        Task { _ = try? await call.sendCustomEvent(message.customEventData) }
    }

    private func sendChecklistProgress() {
        let progress = ChecklistProgress(done: checklist.filter(\.isChecked).count, total: checklist.count)
        guard call != nil, progress != lastSentProgress else { return }
        lastSentProgress = progress
        send(.checklistProgress(done: progress.done, total: progress.total))
    }

    private func handle(_ message: BeanMessage) {
        switch message {
        case .timer(let theirs):
            // The most recent button press wins.
            guard theirs.updatedAt > timer.updatedAt else { return }
            timer = theirs
            timer.advance(to: Date())
        case .checklistProgress(let done, let total):
            friendProgress = ChecklistProgress(done: done, total: total)
        case .photoboothOpen:
            if nextScreen == .call { nextScreen = .photo }
        case .photoboothStart(let startAt):
            if nextScreen == .call { nextScreen = .photo }
            runPhotobooth(startingAt: startAt)
        }
    }

    /// Catches a friend up when they join: our timer (if anyone has touched it) and checklist progress.
    private func greetFriend() {
        if timer.updatedAt > .distantPast {
            send(.timer(timer))
        }
        lastSentProgress = nil
        sendChecklistProgress()
    }

    // MARK: - Private

    private func observe(_ call: Call) {
        call.state.$remoteParticipants
            .receive(on: DispatchQueue.main)
            .sink { [weak self] participants in
                guard let self else { return }
                let friendJustJoined = self.remoteParticipant == nil && participants.first != nil
                self.remoteParticipant = participants.first
                switch self.callStatus {
                case .waitingForFriend where participants.first != nil:
                    self.callStatus = .inCall
                case .inCall where participants.first == nil:
                    self.callStatus = .waitingForFriend
                default:
                    break
                }
                if friendJustJoined { self.greetFriend() }
            }
            .store(in: &callCancellables)

        call.state.$localParticipant
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.localParticipant = $0 }
            .store(in: &callCancellables)

        call.state.$callSettings
            .receive(on: DispatchQueue.main)
            .sink { [weak self] settings in
                self?.micOn = settings.audioOn
                self?.cameraOn = settings.videoOn
            }
            .store(in: &callCancellables)

        eventsTask?.cancel()
        eventsTask = Task { [weak self] in
            for await event in call.subscribe(for: CustomVideoEvent.self) {
                guard let self else { return }
                guard event.user.id != self.currentUser?.id,
                      let message = BeanMessage(customEventData: event.custom) else { continue }
                self.handle(message)
            }
        }
    }

    /// A ringing call was answered from the iPhone call screen; the SDK has already joined it.
    private func adoptAnsweredCall(_ answered: Call) {
        guard let me = currentUser else { return }
        let caller = [answered.state.createdBy].compactMap { $0 }.first { $0.id != me.id }
            ?? answered.state.members.map(\.user).first { $0.id != me.id }
        friendUID = caller?.id
        friendName = caller?.name ?? "your friend"
        timer = SharedTimer(schedule: builtInSchedules[0]) // the caller's timer syncs over when we connect
        resetSessionState()

        call = answered
        observe(answered)
        remoteParticipant = answered.state.remoteParticipants.first
        callStatus = remoteParticipant == nil ? .waitingForFriend : .inCall
        nextScreen = .call
        answeredIncomingCall += 1
    }

    /// Returns a Stream client connected as `user`, creating one the first time.
    private func connectedClient(for user: AppUser) async throws -> StreamVideo {
        if let existing = streamVideo, existing.user.id == user.id {
            return existing
        }
        if let stale = streamVideo {
            await stale.disconnect()
            streamVideo = nil
            clientCancellables.removeAll()
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
        setUpRinging(for: client)
        return client
    }

    /// Hooks the client up to CallKit (the iPhone call screen) and registers this phone for VoIP pushes.
    private func setUpRinging(for client: StreamVideo) {
        InjectedValues[\.callKitAdapter].streamVideo = client

        InjectedValues[\.callKitPushNotificationAdapter].$deviceToken
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak client] token in
                Task { _ = try? await client?.setVoipDevice(id: token) }
            }
            .store(in: &clientCancellables)

        client.state.$activeCall
            .receive(on: DispatchQueue.main)
            .sink { [weak self] active in
                guard let self, let active, self.call == nil else { return }
                if let left = self.recentlyLeft, left.cId == active.cId, Date().timeIntervalSince(left.at) < 5 {
                    return
                }
                self.adoptAnsweredCall(active)
            }
            .store(in: &clientCancellables)
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
