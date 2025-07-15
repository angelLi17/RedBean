//
//  MainAppViewModel.swift
//  RedBean
//
//  Created by Angel on 5/18/25.
//

import SwiftUI
import Foundation
import Combine
// import Firebase Firestore

class HomeViewModel: ObservableObject {
    @Published var errorMessage: String? // WHAT DOES ? MEAN
    @Published var userID: String = ""
    @Published var displayName: String = ""
    @Published var nextScreen: AppScreen = .home
    
    // Menu click states
    @Published var menu1Clicked: Bool = false
    @Published var menu2Clicked: Bool = false
    @Published var menu3Clicked: Bool = false

    // Settings click states
    @Published var set1Clicked: Bool = false
    @Published var set2Clicked: Bool = false
    @Published var set3Clicked: Bool = false
    
    @Published var showSettingsMenu = false

    func menu1Toggle() {
        nextScreen = .contact
        menu1Clicked = true
    }
    
    func menu2Toggle() {
        menu2Clicked = true
        //nextScreen = .shred
    }

    func menu3Toggle() {
        menu3Clicked = true
        //nextScreen = .photobooth
    }

    func set1Toggle() {
        set1Clicked = true
        //nextScreen = .profile
    }

    func set2Toggle() {
        set2Clicked = true
        //nextScreen = .settings
    }

    func set3Toggle() {
        set3Clicked = true
        //nextScreen = .settings
    }
}
