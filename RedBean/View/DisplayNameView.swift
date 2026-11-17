//
//  DisplayNameView.swift
//  RedBean
//
//  Created by Angel on 5/18/25.
//

import SwiftUI

struct DisplayNameView: View {
    @State private var displayName: String = ""
    @State private var phoneNumber: String = ""
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

                VStack(alignment: .leading, spacing: 10) {
                    Text("Phone Number")
                        .font(.custom("Biryani", size: 20))
                        .foregroundColor(.white)

                    Rectangle()
                        .fill(Color("aPink"))
                        .frame(width: 322, height: 66)
                        .overlay(
                            TextField("So friends can find you", text: $phoneNumber)
                                .keyboardType(.phonePad)
                                .textContentType(.telephoneNumber)
                                .font(.custom("Biryani", size: 20))
                                .foregroundColor(Color("aRed"))
                                .padding(.horizontal, 20)
                        )
                }

                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .font(.custom("Biryani", size: 15))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                
                Button(action: {
                    viewModel.completeProfile(
                        name: displayName.trimmingCharacters(in: .whitespacesAndNewlines),
                        phone: phoneNumber
                    )
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
                .disabled(!canContinue)
                .opacity(canContinue ? 1.0 : 0.6)
            }
            .padding(.horizontal, 40)
        }
        .onAppear {
            // Older accounts already have a name; only the phone number is new.
            displayName = viewModel.displayName
            phoneNumber = viewModel.phoneNumber
        }
    }

    private var canContinue: Bool {
        !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && PhoneNumber.normalized(phoneNumber) != nil
    }
}

#Preview {
    DisplayNameView(viewModel: LoginViewModel())
} 
