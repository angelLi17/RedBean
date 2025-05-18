//
//  ContentView.swift
//  RedBean
//
//  Created by Angel on 5/12/25.
//

import SwiftUI

enum AppScreen {
    case loading
    case home
    //case call
    case login
    //case shred //settings
}

struct LoadAppView: View {
    var body: some View {
        ZStack() {
            Text("RedBean")
                .font(.custom("BM Jua", size: 75))
                .foregroundColor(.white)
                .offset(x: -0.50, y: 155)
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 308, height: 308)
                .background(.white)
                .cornerRadius(50)
                .offset(x: 0, y: -67)
        }
        .frame(width: 390, height: 844)
        .background(Color("aRed"))
        .shadow(
            color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
        )
        .padding()
    }
}

struct MainAppView: View {
    @Binding var currentScreen: AppScreen
    var body: some View {
        ZStack() {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 39, height: 39)
                .background(.white)
                .cornerRadius(50)
                .overlay(
                    RoundedRectangle(cornerRadius: 50)
                        .inset(by: 0.50)
                        .stroke(.black, lineWidth: 0.50)
                )
                .offset(x: 159.50, y: -385.50)
            Text("Jane Doe")
                .font(.custom("BM Jua", size: 30))
                .foregroundColor(.white)
                .offset(x: -30, y: -383.50)
            Text("Love,\nRedBean.")
                .font(Font.custom("Inspiration", size: 80))
                .foregroundColor(.white)
                .offset(x: 75.50, y: -48)
            Text("✰notifs\n\n✰settings\n\n✰logout")
                .font(Font.custom("Biryani", size: 25))
                .lineSpacing(25)
                .foregroundColor(Color(red: 0.84, green: 0.37, blue: 0.37))
                .offset(x: 115, y: -255.50)
            Text("✰start a new bean\n\n✰use a custom\nstudy plan\n\n✰bean shredder")
                .font(Font.custom("Biryani", size: 30))
                .lineSpacing(25)
                .foregroundColor(Color(red: 0.84, green: 0.37, blue: 0.37))
                .offset(x: 0.50, y: 244.50)
        }
        .frame(width: 390, height: 844)
        .background(Color("aRed"))
        .shadow(
            color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
        )
    }
}
struct LoginView: View {
    @Binding var currentScreen: AppScreen
    var body: some View {
        ZStack() {

            Text("Welcome, fellow Bean! \nSign in to your account")
                .font(.custom("Biryani", size: 25))
                .foregroundColor(Color("aRed"))
                .offset(x: 0, y: -159.50)
                .multilineTextAlignment(.center)
            Text("Username")
                .font(.custom("Biryani", size: 20))
                .foregroundColor(Color("aRed"))
                .offset(x: -112, y: -81)
            Rectangle()
                .fill(Color("aPink"))
                .frame(width: 322, height: 66)
                .offset(x: 0, y: -38)
            Text("Password")
                .font(.custom("Biryani", size: 20))
                .foregroundColor(Color("aRed"))
                .offset(x: -113, y: 20.50)
            Rectangle()
                .fill(Color("aPink"))
                .frame(width: 322, height: 66)
                .offset(x: 0, y: 63)
            RoundedRectangle(cornerRadius: 90)
                .fill(Color("aRed"))
                .frame(width: 322, height: 66)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.30), radius: 2, y: 4
                )
                .offset(x:0,y:166)
            Text("LOGIN")
                .font(.custom("Biryani", size: 30))
                .foregroundColor(Color(red: 1, green: 0.87, blue: 0.83))
                .offset(x: 0, y: 166)
        }
        .frame(width: 390, height: 844)
        .background(.white)
    }
}
struct ContentView: View {
    @State private var currentScreen: AppScreen = .loading
    var body: some View {
        switch currentScreen {
        case .loading:
            LoadAppView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        currentScreen = .login
                    }
                }
        case .login:
            LoginView(currentScreen: $currentScreen)
        case .home:
            MainAppView(currentScreen: $currentScreen)

//        case .call:
//            <#code#>CallView()
//        case .shred:
//            <#code#>ShredView()
        }
    }
}

#Preview {
    ContentView()
}
