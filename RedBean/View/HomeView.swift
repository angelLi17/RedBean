//
//  MainAppView.swift
//  RedBean
//
//  Created by Angel on 5/18/25.
//
import SwiftUI
struct HomeView: View {
    @State var menu1Clicked: Bool = false
    @State var menu2Clicked: Bool = false
    @State var menu3Clicked: Bool = false
    
    @State var set1Clicked: Bool = false
    @State var set2Clicked: Bool = false
    @State var set3Clicked: Bool = false
    
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
                .onTapGesture {
                    
                }
                .offset(x: 159.50, y: -370)
            Text(homeModel.displayName.isEmpty ? "Welcome!" : homeModel.displayName)
                .font(.custom("Jua", size: 30))
                .frame(width: 200, height: 40, alignment: .trailing)
                .offset(x: 35, y: -370)
                .foregroundColor(Color(.white))
            Text("Love,\nRedBean.")
                .font(Font.custom("Inspiration", size: 80))
                .foregroundColor(.white)
                .offset(x: -50, y: 0)
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
                Text("✰start a new bean")
                    .font(Font.custom("Biryani", size: 30))
                    .foregroundColor(Color(red: 0.84, green: 0.37, blue: 0.37))
                    .background(menu1Clicked ? Color(.gray).opacity(0.3) : Color.clear)
                    .underline(menu1Clicked ? true : false)
                    .onTapGesture {
                        menu1Clicked.toggle()
                        //redirect to contact view
                    }
                    .frame(width: 270, alignment: .leading)
                Text("✰bean shredder")
                    .font(Font.custom("Biryani", size: 30))
                    .foregroundColor(Color(red: 0.84, green: 0.37, blue: 0.37))
                    .background(menu2Clicked ? Color(.gray).opacity(0.3) : Color.clear)
                    .underline(menu2Clicked ? true : false)
                    .onTapGesture {
                        menu2Clicked.toggle()
                        //redirect to shred view
                    }
                    .frame(width: 270, alignment: .leading)
                Text("✰photobooth")
                    .font(Font.custom("Biryani", size: 30))
                    .foregroundColor(Color(red: 0.84, green: 0.37, blue: 0.37))
                    .background(menu3Clicked ? Color(.gray).opacity(0.3) : Color.clear)
                    .underline(menu3Clicked ? true : false)
                    .onTapGesture {
                        menu3Clicked.toggle()
                        //redirect to photobooth view
                    }
                    .frame(width: 270, alignment: .leading)
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
