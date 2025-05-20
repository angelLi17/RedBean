//
//  ContentView.swift
//  RedBean—video app
//
//  Created by Angel on 5/12/25.
//

import SwiftUI

struct ContentView: View {
    @State private var currentScreen: AppScreen = .loading

    var body: some View {
        switch currentScreen {
        case .loading:
            LoadView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        currentScreen = .login
                    }
                }
        case .login:
            LoginView(currentScreen: $currentScreen)
        case .home:
            HomeView(currentScreen: $currentScreen)
        
//        case .call:
//            <#code#>CallView()
//        case .shred:
//            <#code#>ShredView()
//        case .settings:
//            <#code#>Settings()
        }
    }
}

#Preview {
    ContentView()
}
