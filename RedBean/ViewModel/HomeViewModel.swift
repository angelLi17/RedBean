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
    @Published var errorMessage: String?
    private let db = Firestore.firestore()
    @Published var userID: String = ""
        
}
