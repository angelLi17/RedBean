//
//  ContentView.swift
//  RedBean—video app
//
//  Created by Angel on 5/12/25.
// 

import SwiftUI

struct ContentView: View {
    @State private var currentScreen: AppScreen = .loading
    @StateObject var viewModel = LoginViewModel()
    @StateObject var homeModel = HomeViewModel()
    @StateObject var contactModel = ContactViewModel()

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
                LoginView(viewModel: viewModel)
                    .onChange(of: viewModel.userID) { oldValue, newValue in
                        if newValue != "" {
                            if viewModel.displayName.isEmpty {
                                currentScreen = .displayName
                            } else {
                                currentScreen = .home
                                homeModel.userID = viewModel.userID
                                homeModel.displayName = viewModel.displayName
                            }
                        }
                    }
            case .displayName:
                DisplayNameView(viewModel: viewModel)
                    .onChange(of: viewModel.displayName) { oldValue, newValue in
                        if !newValue.isEmpty {
                            currentScreen = .home
                            homeModel.userID = viewModel.userID
                            homeModel.displayName = viewModel.displayName
                        }
                    }
            case .home:
                HomeView(homeModel: homeModel)
                    .onChange(of: homeModel.nextScreen) { oldValue, newValue in
                        if newValue != .home {
                            currentScreen = homeModel.nextScreen
                        }
                    }
            case .contact:
                ContactView(homeModel: homeModel, contactModel: contactModel)
            
//        case .call:
//            <#code#>CallView()
//        case .shred:
//            <#code#>ShredView()
//        case .settings:
//            <#code#>Settings()
//        case .schedule:
//            <#code#>
        }
    }
}

#Preview {
    ContentView()
}
