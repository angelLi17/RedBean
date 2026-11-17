//
//  RedBeanTests.swift
//  RedBeanTests
//
//  Created by Angel on 5/12/25.
//

import Foundation
import Testing
import UIKit
@testable import RedBean

struct RedBeanTests {

    @Test func phoneNumbersInDifferentFormatsMatch() {
        #expect(PhoneNumber.normalized("(555) 123-4567") == "5551234567")
        #expect(PhoneNumber.normalized("+1 555 123 4567") == "5551234567")
        #expect(PhoneNumber.normalized("555.123.4567") == "5551234567")
        #expect(PhoneNumber.normalized("12345") == nil)
    }

    @MainActor
    @Test func bothFriendsGetTheSameCallID() {
        let a = "uidAlice1234567890abcdefghij"
        let b = "uidBob0987654321zyxwvutsrqpo"
        #expect(CallViewModel.callID(a, b) == CallViewModel.callID(b, a))
        #expect(CallViewModel.callID(a, b) != CallViewModel.callID(a, "someoneElse"))
        #expect(CallViewModel.callID(a, b).count <= 64)
    }
}

struct SharedTimerTests {
    let t0 = Date(timeIntervalSince1970: 1_000_000)

    @Test func countsDownWhileRunningAndHoldsWhilePaused() {
        var timer = SharedTimer(workMinutes: 25, breakMinutes: 5)
        #expect(timer.remaining(at: t0) == 25 * 60)

        timer.start(at: t0)
        #expect(timer.remaining(at: t0.addingTimeInterval(60)) == 24 * 60)

        timer.pause(at: t0.addingTimeInterval(60))
        #expect(timer.remaining(at: t0.addingTimeInterval(600)) == 24 * 60)
    }

    @Test func scheduleAlternatesWorkAndBreak() {
        var timer = SharedTimer(workMinutes: 25, breakMinutes: 5)
        timer.start(at: t0)

        let ended = timer.advance(to: t0.addingTimeInterval(25 * 60))
        #expect(ended)
        #expect(timer.isWork == false)
        #expect(timer.remaining(at: t0.addingTimeInterval(25 * 60)) == 5 * 60)

        // A phone that was asleep through a whole break catches up to the right phase.
        timer.advance(to: t0.addingTimeInterval(31 * 60))
        #expect(timer.isWork == true)
        #expect(timer.remaining(at: t0.addingTimeInterval(31 * 60)) == 24 * 60)
    }

    @Test func customBlockStopsAtZero() {
        var timer = SharedTimer(workMinutes: 25, breakMinutes: 5)
        timer.setCustom(minutes: 10, isWork: false, at: t0)
        #expect(timer.isRunning == false)
        timer.start(at: t0)
        let ended = timer.advance(to: t0.addingTimeInterval(10 * 60))
        #expect(ended)
        #expect(timer.isRunning == false)
        #expect(timer.remaining(at: t0.addingTimeInterval(11 * 60)) == 0)
    }

    @Test func untouchedTimerNeverWinsASync() {
        var touched = SharedTimer(workMinutes: 25, breakMinutes: 5)
        touched.start(at: t0)
        let untouched = SharedTimer(workMinutes: 50, breakMinutes: 10)
        #expect(touched.updatedAt > untouched.updatedAt)
    }
}

struct BeanMessageTests {
    @Test func messagesSurviveTheRoundTrip() {
        var timer = SharedTimer(workMinutes: 20, breakMinutes: 10)
        timer.start(at: Date(timeIntervalSince1970: 1_700_000_000))

        let messages: [BeanMessage] = [
            .timer(timer),
            .checklistProgress(done: 2, total: 5),
            .photoboothOpen,
            .photoboothStart(at: Date(timeIntervalSince1970: 1_700_000_123.5)),
        ]
        for message in messages {
            #expect(BeanMessage(customEventData: message.customEventData) == message)
        }
    }

    @Test func ignoresUnrelatedEvents() {
        #expect(BeanMessage(customEventData: ["somethingElse": .string("hi")]) == nil)
    }
}

struct PhotoStripTests {
    @Test func stripIsTheVisibleFrameSize() throws {
        let shot = UIGraphicsImageRenderer(size: CGSize(width: 400, height: 300)).image { context in
            UIColor.red.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 400, height: 300))
        }
        let strip = try #require(PhotoStrip.makeStrip(shots: Array(repeating: shot, count: 4)))
        #expect(strip.size == PhotoStrip.stripArea.size)
    }

    @Test func aspectFillCoversTheWindow() {
        let target = CGRect(x: 0, y: 0, width: 1260, height: 896)
        let filled = PhotoStrip.aspectFill(CGSize(width: 300, height: 400), into: target)
        #expect(filled.width >= target.width && filled.height >= target.height)
        #expect(abs(filled.midX - target.midX) < 0.01 && abs(filled.midY - target.midY) < 0.01)
    }
}
