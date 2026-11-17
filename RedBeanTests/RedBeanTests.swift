//
//  RedBeanTests.swift
//  RedBeanTests
//
//  Created by Angel on 5/12/25.
//

import Testing
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
