//
//  MainAppViewModel.swift
//  RedBean
//
//  Created by Angel on 5/18/25.
//

import SwiftUI
import Foundation
import Combine
import FirebaseFirestore
import Contacts

class CallViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var contacts: [CNContact] = []
    @Published var accessGranted = false
    @Published var nextScreen: AppScreen = .contact //not connected to homeview's screen variable
    
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
}
