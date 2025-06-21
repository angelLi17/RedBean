//
//  DisplayNameView.swift
//  RedBean
//
//  Created by Angel on 5/18/25.
//

import SwiftUI

struct DisplayNameView: View {
    @State private var displayName: String = ""
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        ZStack {
            Color("aRed")
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Welcome to RedBean!")
                    .font(.custom("Inspiration", size: 50))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("What should we call you?")
                    .font(.custom("Biryani", size: 25))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Display Name")
                        .font(.custom("Biryani", size: 20))
                        .foregroundColor(Color("aRed"))
                    
                    Rectangle()
                        .fill(Color("aPink"))
                        .frame(width: 322, height: 66)
                        .overlay(
                            TextField("Enter your name", text: $displayName)
                                .font(.custom("Biryani", size: 20))
                                .foregroundColor(Color("aRed"))
                                .padding(.horizontal, 20)
                        )
                }
                
                Button(action: {
                    if !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        viewModel.setDisplayName(displayName.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                }) {
                    ZStack {
                        Color("aPink")
                            .cornerRadius(90)
                            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.30), radius: 2, y: 4)
                        Text("Continue")
                            .font(.custom("Biryani", size: 25))
                            .foregroundColor(Color("aRed"))
                    }
                    .frame(width: 200, height: 66)
                }
                .disabled(displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .opacity(displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
            }
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    DisplayNameView(viewModel: LoginViewModel())
} 
