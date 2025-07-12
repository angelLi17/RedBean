//
//  Schedules.swift
//  RedBean
//
//  Created by Angel on 5/24/25.
//

import SwiftUI

struct TimerSchedule: Identifiable {
    let id = UUID()
    let name: String
    let workMinutes: Int
    let breakMinutes: Int
}
