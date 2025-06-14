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
                LoginView(viewModel: LoginViewModel())
                .onChange(of: viewModel.userID) { oldValue, newValue in
                        if newValue != "" {
                            currentScreen = .home
                            homeModel.userID = viewModel.userID
                        }
                    }
            case .home:
                HomeView(homeModel: HomeViewModel())
            
        
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
    ContentView()
}
