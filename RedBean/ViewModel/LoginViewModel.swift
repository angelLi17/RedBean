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

    func signIn(username: String, password: String) {
        let result: () = Auth.auth().signIn(withEmail: username, password: password) { result, error in
            if error != nil {
                print (error!.localizedDescription)
            }
        }
        
    }
    
    func register(username: String, password: String) {
        Auth.auth().createUser(withEmail: username, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
        
    }
}
