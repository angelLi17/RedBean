//
//  SharedTimer.swift
//  RedBean
//

import Foundation

/// The study timer both friends see. It's stored as an end time instead of a countdown,
/// so two phones showing the same state stay in step without sending a message every second.
struct SharedTimer: Codable, Equatable {
    enum Mode: String, Codable {
        /// Repeats work → break → work... from the schedule picked on Start a Bean.
        case schedule
        /// One custom block (work or break) that stops when it reaches zero.
        case custom
    }

    var workMinutes: Int
    var breakMinutes: Int
    var mode: Mode = .schedule
    var isWork = true
    /// Length of the current phase, for drawing the ring.
    var phaseSeconds: Int
    var isRunning = false
    /// When the current phase finishes. Only set while running.
    var endsAt: Date?
    /// Seconds left while paused.
    var pausedRemaining: Int
    /// When someone last pressed a button. The newest change wins when friends sync.
    /// Starts in the distant past, so a timer nobody has touched never overwrites a friend's.
    var updatedAt: Date = .distantPast

    init(workMinutes: Int, breakMinutes: Int) {
        self.workMinutes = workMinutes
        self.breakMinutes = breakMinutes
        phaseSeconds = workMinutes * 60
        pausedRemaining = phaseSeconds
    }

    init(schedule: TimerSchedule) {
        self.init(workMinutes: schedule.workMinutes, breakMinutes: schedule.breakMinutes)
    }

    func remaining(at now: Date) -> Int {
        guard isRunning, let endsAt else { return pausedRemaining }
        return max(0, Int(endsAt.timeIntervalSince(now).rounded(.up)))
    }

    /// 1 when a phase starts, 0 when it ends.
    func fraction(at now: Date) -> Double {
        phaseSeconds == 0 ? 0 : Double(remaining(at: now)) / Double(phaseSeconds)
    }

    mutating func start(at now: Date) {
        guard !isRunning, pausedRemaining > 0 else { return }
        isRunning = true
        endsAt = now.addingTimeInterval(TimeInterval(pausedRemaining))
        updatedAt = now
    }

    mutating func pause(at now: Date) {
        guard isRunning else { return }
        pausedRemaining = remaining(at: now)
        isRunning = false
        endsAt = nil
        updatedAt = now
    }

    /// Switches to a single custom block. It starts paused, so both friends can press start together.
    mutating func setCustom(minutes: Int, isWork: Bool, at now: Date) {
        mode = .custom
        self.isWork = isWork
        phaseSeconds = minutes * 60
        pausedRemaining = phaseSeconds
        isRunning = false
        endsAt = nil
        updatedAt = now
    }

    /// Moves past any phases that have finished by `now`. Returns true if a phase ended.
    /// This doesn't touch `updatedAt`: both phones work out the same next phase on their own.
    @discardableResult
    mutating func advance(to now: Date) -> Bool {
        guard isRunning, var end = endsAt, end <= now else { return false }
        switch mode {
        case .custom:
            isRunning = false
            endsAt = nil
            pausedRemaining = 0
        case .schedule:
            repeat {
                isWork.toggle()
                phaseSeconds = (isWork ? workMinutes : breakMinutes) * 60
                end = end.addingTimeInterval(TimeInterval(max(phaseSeconds, 1)))
            } while end <= now
            endsAt = end
        }
        return true
    }
}
