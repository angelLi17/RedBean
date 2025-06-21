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
    @Published var showLoginAlert: Bool = false
    @Published var showSignupAlert: Bool = false
    @Published var showDisplayNameAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var userID: String = ""
    @Published var displayName: String = ""

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                self.showLoginAlert = true
                self.errorMessage = error!.localizedDescription
            } else {
                if let user = Auth.auth().currentUser {
                    self.userID = user.uid
                    self.displayName = user.displayName ?? ""
                }
            }
        }
    }
    
    func register(email: String, password: String) {
         Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if (error != nil) {
                self.showSignupAlert = true
                self.errorMessage = error!.localizedDescription
            } else {
                if let user = Auth.auth().currentUser {
                    self.userID = user.uid
                    self.showDisplayNameAlert = true
                }
            }
        }
    }
    
    func setDisplayName(_ name: String) {
        guard let user = Auth.auth().currentUser else { return }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        
        changeRequest.commitChanges { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.displayName = name
                self.showDisplayNameAlert = false
            }
        }
    }
    
    func setDisplayPic(_ url: String) {
        guard let user = Auth.auth().currentUser else { return }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.photoURL = URL(string: url)
        
        changeRequest.commitChanges { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.showDisplayNameAlert = false
            }
        }
    }
}
