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
import FirebaseFirestore

class LoginViewModel: ObservableObject {
    @Published var showLoginAlert: Bool = false
    @Published var showSignupAlert: Bool = false
    @Published var showDisplayNameAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var userID: String = ""
    @Published var displayName: String = ""
    @Published var appUser: AppUser!
    @Published var phoneNumber: String = ""
    /// Flips to true once the profile screen has saved a display name and phone number.
    @Published var profileComplete: Bool = false

    /// New users, and older accounts made before phone numbers were collected, need the profile screen.
    var needsProfileSetup: Bool {
        displayName.isEmpty || phoneNumber.isEmpty
    }

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                self.showLoginAlert = true
                self.errorMessage = error!.localizedDescription
            } else {
                if let user = Auth.auth().currentUser {
                    // Load the saved phone number first: ContentView routes as soon as userID changes.
                    Firestore.firestore().collection("users").document(user.uid).getDocument { snapshot, _ in
                        let phone = snapshot?.data()?["phone"] as? String ?? ""
                        self.phoneNumber = phone
                        self.displayName = user.displayName ?? ""
                        self.appUser = AppUser(
                            id: user.uid,
                            name: user.displayName,
                            imageURL: user.photoURL?.absoluteString,
                            phonenum: phone
                        )
                        self.userID = user.uid
                    }
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
    
    /// Saves the display name and phone number, and publishes the number so friends' Contacts can find this account.
    func completeProfile(name: String, phone: String) {
        guard let user = Auth.auth().currentUser else { return }
        guard let normalized = PhoneNumber.normalized(phone) else {
            errorMessage = "Please enter a 10-digit phone number."
            return
        }
        errorMessage = ""

        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            let db = Firestore.firestore()
            let batch = db.batch()
            batch.setData(["uid": user.uid], forDocument: db.collection("phoneToUID").document(normalized))
            batch.setData(["phone": normalized, "displayName": name],
                          forDocument: db.collection("users").document(user.uid), merge: true)
            batch.commit { error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                self.displayName = name
                self.phoneNumber = normalized
                self.appUser?.name = name
                self.appUser?.phonenum = normalized
                self.profileComplete = true
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
