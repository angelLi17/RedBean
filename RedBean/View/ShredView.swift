//
//  ShredView.swift
//  RedBean
//
//  Created by Angel on 5/18/25.
//
import SwiftUI
import FirebaseCore
import FirebaseAuth

struct ShredView: View {
    @StateObject private var viewModel = LoginViewModel()
    @Binding var currentScreen: AppScreen
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        ZStack() {
            Form {
                TextField(text: $username, prompt: Text("vent here...then shred it up, take a walk and keep at it. nothing you type here will be seen by anyone else. You've got this!")) {
                    Text("Username")
                        .font(.custom("Biryani", size: 20))
                        .foregroundColor(Color("aRed"))
                        .offset(x: -112, y: -81)
                }
            }
        }
        
        
    }
}
