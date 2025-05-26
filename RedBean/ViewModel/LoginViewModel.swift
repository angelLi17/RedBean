//
//  LoginViewModel.swift
//  RedBean
//
//  Created by Angel on 5/18/25.
// 

import SwiftUI
import Foundation
import Combine
import FirebaseCore
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @State private var showLoginAlert = false
    @State private var showSignupAlert = false
    @State private var errorMessage = ""
    @Published var userID: String = ""

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                self.showLoginAlert = true
                self.errorMessage = error!.localizedDescription
            }
        }
        if let user = Auth.auth().currentUser {
            userID = user.uid
        }
    }
    
    func register(email: String, password: String) {
         Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if (error != nil) {
                self.showSignupAlert = true
                self.errorMessage = error!.localizedDescription
            }
        }
        if let user = Auth.auth().currentUser {
            userID = user.uid
        }
    }
}
