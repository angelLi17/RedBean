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


//settings menu
            Color("aRed")
                .frame(width: 427, height: 67)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.30), radius: 2, y: 4
                )
                .offset(x: 96, y: -370)

            Color("aPink")
                .cornerRadius(20)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.30), radius: 2, y: 4
                )
                .overlay(
                    Text("appetizers:")
                        .font(.custom("Biryani", size: 20))
                        .foregroundColor(Color("aRed"))
                        .padding(.bottom, 240)
                )
                .frame(width: 95, height: 145)
                .offset(x: 96, y: -246)
                .opacity(homeModel.showSettingsMenu ? 1 : 0)
                //profile button
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
                .onTapGesture {
                    withAnimation {
                        homeModel.showSettingsMenu.toggle()
                    }
                }
                .offset(x: 105, y: -370)
            if homeModel.showSettingsMenu {
                VStack(spacing: 25) {
                    Button(action: { //all buttons grey only where text idk how to fix
                        homeModel.set1Toggle()
                    }) {
                        Text("✰profile")
                            .font(Font.custom("Biryani", size: 24))
                            .foregroundColor(Color("aRed"))
                            .background(homeModel.set1Clicked ? Color(.gray).opacity(0.3) : Color.clear)
                            .underline(homeModel.set1Clicked ? true : false)
                    }
                    .frame(width: 160, alignment: .leading)
                    .padding(8)
                    Button(action: {
                        homeModel.set2Toggle()
                    }) {
                        Text("✰settings")
                            .font(Font.custom("Biryani", size: 24))
                            .foregroundColor(Color("aRed"))
                            .background(homeModel.set2Clicked ? Color(.gray).opacity(0.3) : Color.clear)
                            .underline(homeModel.set2Clicked ? true : false)
                    }
                    .frame(width: 160, alignment: .leading)
                    .padding(8)
                    Button(action: {
                        homeModel.set3Toggle()
                    }) {
                        Text("✰logout")
                            .font(Font.custom("Biryani", size: 24))
                            .foregroundColor(Color("aRed"))
                            .background(homeModel.set3Clicked ? Color(.gray).opacity(0.3) : Color.clear)
                            .underline(homeModel.set3Clicked ? true : false)
                    }
                    .frame(width: 160, alignment: .leading)
                    .padding(8)
                }
                .background(
                    Color.white
                        .cornerRadius(16)
                        .padding(.horizontal, 8)
                )
                .frame(width: 160, height: 130)
                .offset(x: 96, y: -246)
            }

//welcome text
            Text(homeModel.displayName.isEmpty ? "Welcome!" : homeModel.displayName)
                .font(.custom("Jua", size: 30))
                .frame(width: 200, height: 40, alignment: .trailing)
                .offset(x: 35, y: -370)
                .foregroundColor(Color(.white))
            Text("Love,\nRedBean.")
                .font(Font.custom("Inspiration", size: 80))
                .foregroundColor(.white)
                .offset(x: -50, y: 0)

//menu
            Color("aPink")
                .cornerRadius(20)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.30), radius: 2, y: 4
                )
                .overlay(
                    Text("serving our special menu:")
                        .font(.custom("Biryani", size: 20))
                        .foregroundColor(Color("aRed"))
                        .padding(.bottom, 240)
                )
                .frame(width: 322, height: 278)
                .offset(x: 0, y: 250)
            VStack(spacing: 25) {
                Button(action: {
                    homeModel.menu1Toggle()
                }) {
                    Text("✰start a new bean")
                        .font(Font.custom("Biryani", size: 30))
                        .foregroundColor(Color(red: 0.84, green: 0.37, blue: 0.37))
                        .background(homeModel.menu1Clicked ? Color(.gray).opacity(0.3) : Color.clear)
                        .underline(homeModel.menu1Clicked ? true : false)
                }
                    .frame(width: 270, alignment: .leading)
                Button(action: {
                    homeModel.menu2Toggle()
                }) {
                    Text("✰bean shredder")
                        .font(Font.custom("Biryani", size: 30))
                        .foregroundColor(Color(red: 0.84, green: 0.37, blue: 0.37))
                        .background(homeModel.menu2Clicked ? Color(.gray).opacity(0.3) : Color.clear)
                        .underline(homeModel.menu2Clicked ? true : false)
                        .frame(width: 270, alignment: .leading)
                }
                Button(action: {
                    homeModel.menu3Toggle()
                }) {
                    Text("✰photobooth")
                        .font(Font.custom("Biryani", size: 30))
                        .foregroundColor(Color(red: 0.84, green: 0.37, blue: 0.37))
                        .background(homeModel.menu3Clicked ? Color(.gray).opacity(0.3) : Color.clear)
                        .underline(homeModel.menu3Clicked ? true : false)
                        .frame(width: 270, alignment: .leading)
                }
            }
            .frame(width: 322, height: 230)
            .offset(x: 0, y: 260)
            .background(
                ZStack {
                    Color(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                }
                .offset(x: 0, y: 260)
            )
        }
    }
}
#Preview {
    HomeView(homeModel: HomeViewModel())
}
