//
//  MainAppView.swift
//  RedBean
//
//  Created by Angel on 5/18/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State private var userID: String = ""
    
    init(userID: String) {
        self.userID = userID
        _viewModel = StateObject(wrappedValue: HomeViewModel(userID: userID))
    }
    
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

#Preview {
    HomeView(userID: "angel")
}

