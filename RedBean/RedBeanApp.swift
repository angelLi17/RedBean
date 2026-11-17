//
//  RedBeanApp.swift
//  RedBean
//
//  Created by Angel on 5/12/25.
//

import SwiftUI
import FirebaseCore
import StreamVideo
import StreamVideoSwiftUI
import Contacts

@main
struct RedBeanApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    
    
    @State var streamVideo: StreamVideoUI?
    
    init() {
        FirebaseApp.configure()
    }
}


