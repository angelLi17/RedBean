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
    @State var showLoginAlert = false

    func signIn(email: String, password: String) {
        let result: () = Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print (error!.localizedDescription)
            }
        }
        
    }
    
    func register(email: String, password: String) {
        var showalert = false
        Auth.auth().createUser(withEmail: email, password: password) { [self] result, error in
            if (error != nil) {
                showLoginAlert = true
            }
            AlertScene("Sign Up Error", isPresented: $showLoginAlert) {
            } message: {
                Text(error!.localizedDescription)
            }
        }
        
    }
}
