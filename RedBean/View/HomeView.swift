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
            GeometryReader { geometry in
                Image("Bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
//settings menu
            Color("aRed")
                .frame(width: 427, height: 50)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.30), radius: 2, y: 4
                )
                .opacity(0.7)
                .offset(y: -370)

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
                .offset(x: 158, y: -370)
            if homeModel.showSettingsMenu {
            VStack(alignment: .leading, spacing: 15) {
                    Button(action: { //all buttons grey only where text idk how to fix also they r still grey after stop clicking think its fixed but gotta change the view to fix it
                        homeModel.set1Toggle()
                    }) {
                        Text("✰profile")
                            .font(Font.custom("Biryani", size: 24))
                            .foregroundColor(Color("aRed"))
                            .background(homeModel.set1Clicked ? Color(.gray).opacity(0.3) : Color.clear)
                            .underline(homeModel.set1Clicked ? true : false)
                    }
                    .padding(16)
                    Button(action: {
                        homeModel.set2Toggle()
                    }) {
                        Text("✰settings")
                            .font(Font.custom("Biryani", size: 24))
                            .foregroundColor(Color("aRed"))
                            .background(homeModel.set2Clicked ? Color(.gray).opacity(0.3) : Color.clear)
                            .underline(homeModel.set2Clicked ? true : false)
                    }
                    .padding(16)
                    Button(action: {
                        homeModel.set3Toggle()
                    }) {
                        Text("✰logout")
                            .font(Font.custom("Biryani", size: 24))
                            .foregroundColor(Color("aRed"))
                            .background(homeModel.set3Clicked ? Color(.gray).opacity(0.3) : Color.clear)
                            .underline(homeModel.set3Clicked ? true : false)
                    }
                    .padding(16)
                }
                .background {
                    Color("aPink")
                        .cornerRadius(16)
                        .shadow(
                            color: Color(red: 0, green: 0, blue: 0, opacity: 0.5), radius: 4, y: 4
                        )
                    Color.white
                        .cornerRadius(10)
                        .padding(5)
                }
                .frame(width: 160, height: 100)
                .offset(x: 102, y: -206)

            }

//welcome text
            Text(homeModel.displayName.isEmpty ? "Welcome!" : homeModel.displayName)
                .font(.custom("Jua", size: 30))
                .frame(width: 200, height: 40, alignment: .trailing)
                .offset(x: 35, y: -370)
                .foregroundColor(Color(.white))
//            Text("Love,\nRedBean.")
//                .font(Font.custom("Inspiration", size: 80))
//                .foregroundColor(.white)
//                .offset(x: -50, y: 0)

//menu
            Color("aPink")
                .cornerRadius(20)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.7), radius: 4, y: 4
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
                        .contentShape(Rectangle())
                        .background(homeModel.menu1Clicked ? Color(.gray).opacity(0.3) : Color.clear)
                        .underline(homeModel.menu1Clicked ? true : false)
                }
                    .frame(width: 270, alignment: .leading)
                Button(action: {
                    homeModel.menu2Toggle()
                }) {
                    Text("✰bean shredder")
                        .contentShape(Rectangle())
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
                        .contentShape(Rectangle())
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
