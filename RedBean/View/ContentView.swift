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
    @StateObject var callModel = CallViewModel()
    @StateObject var photoModel = PhotoViewModel()

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
                            homeModel.menu1Clicked = false
                            homeModel.menu2Clicked = false
                            homeModel.menu3Clicked = false
                            homeModel.set1Clicked = false
                            homeModel.set2Clicked = false
                            homeModel.set3Clicked = false
                            homeModel.showSettingsMenu = false
                            let temp = homeModel.nextScreen
                            homeModel.nextScreen = .home
                            contactModel.nextScreen = .contact //maybe need to do "if, newValue is .contact but maybe not
                            currentScreen = temp
                        }
                    }
            case .contact:
                ContactView(homeModel: homeModel, contactModel: contactModel)
                    .onChange(of: contactModel.nextScreen) { oldValue, newValue in
                        currentScreen = contactModel.nextScreen
                    }
            case .call:
            CallView(callModel: callModel, contactModel: contactModel, timeRemaining: callModel.builtInSchedules[contactModel.selectedSchedule ?? 0].workMinutes)
                    .onChange(of: callModel.nextScreen) { oldValue, newValue in
                        currentScreen = callModel.nextScreen
                    }
            case .photo:
                PhotoView(photoModel: photoModel)
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
