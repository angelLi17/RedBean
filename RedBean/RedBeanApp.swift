//
//  RedBeanApp.swift
//  RedBean
//
//  Created by Angel on 5/12/25.
//

import SwiftUI
import FirebaseCore

import Contacts

@main
struct RedBeanApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    init() {
        FirebaseApp.configure()
    }
    
}


