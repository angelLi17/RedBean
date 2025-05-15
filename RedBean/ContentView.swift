//
//  ContentView.swift
//  RedBean
//
//  Created by Angel on 5/12/25.
//

import SwiftUI

struct ContentView: View {
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
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 308, height: 308)
                .background(.white)
                .cornerRadius(50)
                .offset(x: 0, y: -67)
        }
        .frame(width: 390, height: 844)
        .background(Color(red: 0.835, green: 0.36, blue: 0.36))
        .shadow(
            color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
        )
        .padding()
    }
}

#Preview {
    ContentView()
}
