//
//  LoginView.swift
//  RedBean
//
//  Created by Angel on 5/18/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        ZStack() {
            Text("Welcome, fellow Bean! \nSign in to your account")
                .font(.custom("Biryani", size: 25))
                .foregroundColor(Color("aRed"))
                .offset(x: 0, y: -159.50)
                .multilineTextAlignment(.center)
            Text("Email")
                .font(.custom("Biryani", size: 20))
                .foregroundColor(Color("aRed"))
                .offset(x: -134, y: -81)
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
            VStack {
                TextField("",text: $email, prompt: Text("redbeansoup@gmail.com"))
                    .font(Font.custom("Biryani", size: 20))
                    .foregroundColor(Color("aRed"))
                    .offset(x: 0, y: -2)
                    .frame(width: 322, height: 66)
                SecureField("",text: $password, prompt: Text("********"))
                    .font(.custom("Biryani", size: 20))
                    .foregroundColor(Color("aRed"))
                    .offset(x: 0, y: 25)
                    .frame(width: 322, height: 66)
            }
            .disableAutocorrection(true)

            Button(action: {viewModel.signIn(email: email, password: password)}) {
                Text("Login")
                    .font(.custom("Biryani", size: 25))
                    .foregroundColor(Color("aPink"))
            }
            .background(Color("aRed"))
            .cornerRadius(90)
            .frame(width: 154, height: 66)
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.30), radius: 2, y: 4
            )
            .offset(x: -84, y: 166)
            .alert("Sign In Error", isPresented: $viewModel.showLoginAlert) {
                Button("OK", role: .cancel) {
                    viewModel.showLoginAlert = false
                }
            } message: {
                Text(viewModel.errorMessage)
            }
            
            Button(action: {viewModel.register(email: email, password: password)}) {
                Text("Sign Up")
                    .font(.custom("Biryani", size: 25))
                    .foregroundColor(Color("aRed"))
            }
            .background(Color("aPink"))
            .cornerRadius(90)
            .frame(width: 159, height: 66)
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.30), radius: 2, y: 4
            )
            .offset(x: 82, y: 166)
            .alert("Sign Up Error", isPresented: $viewModel.showSignupAlert) {
                Button("OK", role: .cancel) {
                    viewModel.showSignupAlert = false
                }
            } message: {
                Text(viewModel.errorMessage)
            }
            // do reset pw and confirm email later
        }
        .frame(width: 390, height: 844)
        .background(.white)
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
}
