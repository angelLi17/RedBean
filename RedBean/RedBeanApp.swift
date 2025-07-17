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
        setupStreamVideo(with: "4st736tzv8tv", userCredentials: .demoUser)
    }

    private func setupStreamVideo(
        with apiKey: String,
        userCredentials: UserCredentials
    ) {
        streamVideo = StreamVideoUI(
            apiKey: apiKey,
            user: userCredentials.user,
            token: userCredentials.token,
            tokenProvider: { result in
                // Call your networking service to generate a new token here.
                // When finished, call the result handler with either .success or .failure.
                result(.success(userCredentials.token))
            }
        )
    }
    
}


