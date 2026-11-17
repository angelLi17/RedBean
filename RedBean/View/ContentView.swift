//
//  ContentView.swift
//  RedBean—video app
//
//  Created by Angel on 5/12/25.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var currentScreen: AppScreen = .loading
    @StateObject var viewModel = LoginViewModel()
    @StateObject var homeModel = HomeViewModel()
    @StateObject var contactModel = ContactViewModel()
    @StateObject var callModel = CallViewModel()

    var body: some View {
        screen
            // A ringing call answered from the iPhone call screen opens the call from anywhere.
            .onChange(of: callModel.answeredIncomingCall) { _, _ in
                currentScreen = .call
            }
    }

    @ViewBuilder
    private var screen: some View {
        switch currentScreen {
            case .loading:
                LoadView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            // Firebase remembers who signed in last time; skip the login screen for them.
                            if let user = Auth.auth().currentUser {
                                viewModel.restoreSession(for: user)
                            } else {
                                currentScreen = .login
                            }
                        }
                    }
                    .onChange(of: viewModel.userID) { _, newValue in
                        if !newValue.isEmpty { routeAfterSignIn() }
                    }
            case .login:
                LoginView(viewModel: viewModel)
                    .onChange(of: viewModel.userID) { oldValue, newValue in
                        if newValue != "" { routeAfterSignIn() }
                    }
            case .displayName:
                DisplayNameView(viewModel: viewModel)
                    .onChange(of: viewModel.profileComplete) { oldValue, newValue in
                        if newValue { goHome() }
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
                        if newValue == .call, let friend = contactModel.selectedFriend {
                            callModel.prepareBean(
                                friendUID: friend.uid,
                                friendName: friend.name,
                                schedule: selectedSchedule
                            )
                        }
                        currentScreen = contactModel.nextScreen
                    }
            case .call:
                CallView(callModel: callModel)
                    .onChange(of: callModel.nextScreen) { oldValue, newValue in
                        currentScreen = newValue
                    }
            case .photo:
                PhotoView(callModel: callModel)
                    .onChange(of: callModel.nextScreen) { oldValue, newValue in
                        currentScreen = newValue
                    }
//        case .shred:
//            <#code#>ShredView()
//        case .settings:
//            <#code#>Settings()
//        case .schedule:
//            <#code#>
        }
    }

    /// The schedule picked on the Start a Bean screen (its rows are numbered 1...3).
    private var selectedSchedule: TimerSchedule {
        let schedules = callModel.builtInSchedules
        let index = (contactModel.selectedSchedule ?? 1) - 1
        return schedules[min(max(index, 0), schedules.count - 1)]
    }

    private func routeAfterSignIn() {
        if viewModel.needsProfileSetup {
            currentScreen = .displayName
        } else {
            goHome()
        }
    }

    private func goHome() {
        homeModel.userID = viewModel.userID
        homeModel.displayName = viewModel.displayName
        currentScreen = .home
        // Connect to Stream now so friends can ring this phone.
        callModel.currentUser = viewModel.appUser
        Task { await callModel.connect() }
    }
}

#Preview {
    ContentView()
}
