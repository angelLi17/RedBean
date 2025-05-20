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
    @State var email: String = ""
    @State var password: String = ""
    
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
            
            // note to self - start working tomorrow on the alert for login errors in LoginViewModel and adjusting the Button formatting. then try to add like database for contact list? do reset pw and confirm email later
        }
        .frame(width: 390, height: 844)
        .background(.white)
    }
}

#Preview {
    LoginView(currentScreen: .constant(.login))
}

