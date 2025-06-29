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
            GeometryReader { geometry in
                Image("loginBg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
            .edgesIgnoringSafeArea(.all)
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
                .fill(Color("aRed"))
                .frame(width: 322, height: 66)
                .offset(x: 0, y: -38)
            Rectangle()
                .fill(Color("aPink"))
                .frame(width: 318, height: 62)
                .offset(x: 0, y: -38)
            Text("Password")
                .font(.custom("Biryani", size: 20))
                .foregroundColor(Color("aRed"))
                .offset(x: -113, y: 20.50)
            Rectangle() //bad syntax here, learn to use .background
                .fill(Color("aRed"))
                .frame(width: 322, height: 66)
                .offset(x: 0, y: 63)
            Rectangle()
                .fill(Color("aPink"))
                .frame(width: 318, height: 62)
                .offset(x: 0, y: 63)
            VStack {
                TextField("",text: $email, prompt: Text("soup at redbean dot com")) //this turns blue when i use actual @ symbol how do i fix that
                    .font(Font.custom("Biryani", size: 20))
                    .foregroundStyle(Color("aRed"))
                    .offset(x: 0, y: -2)
                    .frame(width: 302, height: 66)
                SecureField("",text: $password, prompt: Text("********"))
                    .font(.custom("Biryani", size: 20))
                    .foregroundStyle(Color("aRed"))
                    .offset(x: 0, y: 25)
                    .frame(width: 302, height: 66)
            }
            .disableAutocorrection(true)

            Button(action: {viewModel.signIn(email: email, password: password)}) {
                
                ZStack {
                    Color("aRed")
                        .cornerRadius(90)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.30), radius: 2, y: 4)
                    Text("LOGIN")
                        .font(.custom("Biryani", size: 25))
                        .foregroundColor(Color("aPink"))
                }
                .frame(width: 150, height: 66)
            }
            .background(Color("aRed"))
            .cornerRadius(90)
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.30), radius: 2, y: 4
            )
            .offset(x: -86, y: 166)
            .alert("Sign In Error", isPresented: $viewModel.showLoginAlert) {
                Button("OK", role: .cancel) {
                    viewModel.showLoginAlert = false
                }
            } message: {
                Text(viewModel.errorMessage)
            }
            
            Button(action: { viewModel.register(email: email, password: password) }) {
                ZStack {
                    Color("aPink")
                        .cornerRadius(90)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.30), radius: 2, y: 4)
                        .padding(2)
                    Text("SIGN UP")
                        .font(.custom("Biryani", size: 25))
                        .foregroundColor(Color("aRed"))
                }
                .frame(width: 159, height: 66)
            }
            .offset(x: 82, y: 166)
            .alert("Sign Up Error", isPresented: $viewModel.showSignupAlert) {
                    Button("OK", role: .cancel) {
                        viewModel.showSignupAlert = false
                    }
                } message: {
                    Text(viewModel.errorMessage)
                }
                .background{
                    Color("aRed")
                        .cornerRadius(90)
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.30), radius: 2, y: 4)
                        .offset(x: 82, y: 166)
                }
            // do reset pw and confirm email later
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
}
