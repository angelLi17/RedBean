//
//  LoadAppView.swift
//  RedBean
//
//  Created by Angel on 5/18/25.
//

import SwiftUI

struct LoadView: View {
    var body: some View {
        ZStack() {
            Color("aRed")
                .ignoresSafeArea()
            Text("RedBean")
                .font(.custom("Jua", size: 75)) //or is it BM Jua..fontspace name is BM??
                .foregroundColor(.white)
                .offset(x: -0.50, y: 155)
            Image("Logo2")
                .resizable()
                .foregroundColor(.clear)
                .scaledToFill()
                .frame(width: 308, height: 308)
                .background(Color(.white))
                .cornerRadius(50)
                .offset(x: 0, y: -67)
        }
        .shadow(
            color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
        )
    }
}

#Preview {
    LoadView()
}
