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

class HomeViewModel: ObservableObject {
    @Published var errorMessage: String? // WHAT DOES ? MEAN
    @Published var userID: String = ""
    @Published var nextScreen: AppScreen = .home
        
    //functions for when click this button switch screens
}
