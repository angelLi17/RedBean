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
    @StateObject private var viewModel = LoginViewModel()
    @Binding var currentScreen: AppScreen
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        ZStack() {
            Text("Welcome, fellow Bean! \nSign in to your account")
                .font(.custom("Biryani", size: 25))
                .foregroundColor(Color("aRed"))
                .offset(x: 0, y: -159.50)
                .multilineTextAlignment(.center)
//            Text("Username")
//                .font(.custom("Biryani", size: 20))
//                .foregroundColor(Color("aRed"))
//                .offset(x: -112, y: -81)
            Rectangle()
                .fill(Color("aPink"))
                .frame(width: 322, height: 66)
                .offset(x: 0, y: -38)
//            Text("Password")
//                .font(.custom("Biryani", size: 20))
//                .foregroundColor(Color("aRed"))
//                .offset(x: -113, y: 20.50)
            Rectangle()
                .fill(Color("aPink"))
                .frame(width: 322, height: 66)
                .offset(x: 0, y: 63)
            Form {
                TextField(text: $username, prompt: Text("redbeansoup@gmail.com")) {
                    Text("Username")
                        .font(.custom("Biryani", size: 20))
                        .foregroundColor(Color("aRed"))
                        .offset(x: -112, y: -81)
                }
                    .disableAutocorrection(true)
                SecureField(text: $password, prompt: Text("qqmochi123")) {
                    Text("Password")
                        .font(.custom("Biryani", size: 20))
                        .foregroundColor(Color("aRed"))
                        .offset(x: -113, y: 20.50)
                }
                    .disableAutocorrection(true)
            }

            RoundedRectangle(cornerRadius: 90)
                .fill(Color("aRed"))
                .frame(width: 322, height: 66)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.30), radius: 2, y: 4
                )
                .offset(x:0,y:166)
            Text("LOGIN")
                .font(.custom("Biryani", size: 30))
                .foregroundColor(Color(red: 1, green: 0.87, blue: 0.83))
                .offset(x: 0, y: 166)
            Button(action:               {viewModel.signIn(username: username, password: password)}) {
                Text("Login")
                    .font(.custom("Biryani", size: 30))
                    .foregroundColor(Color(red: 1, green: 0.87, blue: 0.83))
                    .offset(x: 0, y: 166)
            }
            .onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        //switch to home
                    }
                }
            }
            Button(action:               {viewModel.register(username: username, password: password)}) {
                Text("Register")
                    .font(.custom("Biryani", size: 30))
                    .foregroundColor(Color(red: 1, green: 0.87, blue: 0.83))
                    .offset(x: 0, y: 166)
            }
        }
        .frame(width: 390, height: 844)
        .background(.white)
    }
}

#Preview {
    LoginView(currentScreen: .constant(.login))
}

