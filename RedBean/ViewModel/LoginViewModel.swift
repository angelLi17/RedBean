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
    @Published var appUser: AppUser!

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                self.showLoginAlert = true
                self.errorMessage = error!.localizedDescription
            } else {
                if let user = Auth.auth().currentUser {
                    self.userID = user.uid
                    self.displayName = user.displayName ?? ""
                    self.appUser = AppUser(
                        id: user.uid,
                        name: user.displayName,
                        imageURL: user.photoURL?.absoluteString,
                        phonenum: user.phoneNumber ?? ""
                    )
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
                if let isNewUser = result?.additionalUserInfo?.isNewUser {
                    if isNewUser {
                        if let user = Auth.auth().currentUser {
                            self.userID = user.uid
                            self.showDisplayNameAlert = true
                            self.appUser = AppUser(
                                id: user.uid,
                                name: user.displayName,
                                imageURL: user.photoURL?.absoluteString,
                                phonenum: user.phoneNumber ?? ""
                            )
                        }
                    } else {
                        self.errorMessage = "Please select the LOGIN button instead!"
                        self.showSignupAlert = true
                    }
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
                self.appUser.name = name
            }
        }
    }
    
    func setDisplayPic(_ url: String) {
        guard let user = Auth.auth().currentUser else { return }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.photoURL = URL(string: url)
        self.appUser.imageURL = url
        
        changeRequest.commitChanges { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.showDisplayNameAlert = false
                //change image
            }
        }
    }
}
