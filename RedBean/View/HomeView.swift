//
//  MainAppView.swift
//  RedBean
//
//  Created by Angel on 5/18/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var homeModel: HomeViewModel
    
    var body: some View {
        ZStack() {
            Color("aRed")
                .ignoresSafeArea()
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
            Text(homeModel.displayName.isEmpty ? "Welcome!" : homeModel.displayName)
                .font(.custom("Jua", size: 30))
                .foregroundColor(Color(.white))
                .offset(x: -30, y: -383.50)
            Text("Love,\nRedBean.")
                .font(Font.custom("Inspiration", size: 80))
                .foregroundColor(.white)
                .offset(x: -50, y: -48)
            VStack(alignment: .leading, spacing: 25) {
                Text("✰start a new bean")
                    .font(Font.custom("Biryani", size: 30))
                    .foregroundColor(Color(red: 0.84, green: 0.37, blue: 0.37))
                Text("✰bean shredder")
                    .font(Font.custom("Biryani", size: 30))
                    .foregroundColor(Color(red: 0.84, green: 0.37, blue: 0.37))
                Text("✰photobooth")
                    .font(Font.custom("Biryani", size: 30))
                    .foregroundColor(Color(red: 0.84, green: 0.37, blue: 0.37))
            }
            .frame(width: 322, height: 278)
            .offset(x: 0, y: 250)
            .background(
                ZStack {
                    Color("aPink")
                        .cornerRadius(20)
                        .shadow(
                            color: Color(red: 0, green: 0, blue: 0, opacity: 0.30), radius: 2, y: 4
                        )
                        .overlay(
                            Text("serving today's menu")
                                .font(.custom("Biryani", size: 20))
                                .foregroundColor(Color("aRed"))
                                .padding(.bottom, 240)
                        )
                    Color(.white)
                        .cornerRadius(10)
                        .padding(.top, 32)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                
                        
                }
                .offset(x: 0, y: 250)
            )
            
        }
    }
}

#Preview {
    HomeView(homeModel: HomeViewModel())
}

