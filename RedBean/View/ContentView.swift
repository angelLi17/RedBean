//
//  ContentView.swift
//  RedBean—video app
//
//  Created by Angel on 5/12/25.
//

import SwiftUI

struct ContentView: View {
    @State private var currentScreen: AppScreen = .loading
    @Binding var userID: String

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
                LoginView(userID: userID)
                .onChange(of: userID) { oldValue, newValue in
                        if newValue != "" {
                            currentScreen = .home
                        }
                    }
            case .home:
                HomeView(userID: userID)
            
        
//        case .call:
//            <#code#>CallView()
//        case .shred:
//            <#code#>ShredView()
//        case .settings:
//            <#code#>Settings()
//        case .contact:
//            <#code#>
//        case .schedule:
//            <#code#>
        }
    }
}

#Preview {
    ContentView(userID: <#Binding<String>#>)
}
