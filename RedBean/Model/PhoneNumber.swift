//
//  PhoneNumber.swift
//  RedBean
//

import Foundation

enum PhoneNumber {
    /// Turns "(555) 123-4567", "+1 555 123 4567" and "5551234567" into the same key ("5551234567"),
    /// so a number typed at sign-up matches how it's saved in someone's Contacts.
    /// Uses the last 10 digits (US/Canada style numbers). Returns nil if there are fewer than 10 digits.
    static func normalized(_ raw: String) -> String? {
        let digits = raw.filter(\.isNumber)
        guard digits.count >= 10 else { return nil }
        return String(digits.suffix(10))
    }
}
