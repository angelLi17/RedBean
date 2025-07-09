//
//  ContactView.swift
//  RedBean
//
//  Created by Angel on 5/24/25.
//

import SwiftUI

struct ContactView: View {
    @ObservedObject var homeModel: HomeViewModel
    @ObservedObject var contactModel : ContactViewModel
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("Bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    
            }
            VStack() {
                //header
                ZStack {
                    GeometryReader { geometry in
                        Color("aPink")
                            .frame(width: 427, height: 50)
                            .shadow(
                                color: Color(red: 0, green: 0, blue: 0, opacity: 0.30), radius: 2, y: 4
                            )
                            .opacity(0.9)
                    }
                    HStack(spacing: 70) {
                        Text("Start a Bean")
                            .font(.custom("Jua", size: 30))
                            .foregroundColor(Color("aRed"))
                        Image("HomeIcon")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                    }
                }
                //footer
                HStack(spacing:15) {
                    Rectangle()
                        .frame(width:65, height:42)
                        .foregroundColor(Color("aPink"))
                        .cornerRadius(10)
                    Text("START")
                        .foregroundColor(Color.white)
                        .font(.custom("Biryani", size: 20))
                        .frame(width:171, height:42)
                        .background(Color("aRed"))
                    Rectangle()
                        .frame(width:65, height:42)
                        .foregroundColor(Color("aPink"))
                        .cornerRadius(10)
                }
                
            }
//            Button("Request Contacts Access") {
//                contactModel.requestAccess()
//            }
//            List {
//                Section(header: Text("Contacts")) {
//                    ForEach(contactModel.contacts) { contact in
//                        Text(contact.name)
//                        Circle(contact.pfp)
//                    }
//                }
//            }
            
        }
    }
}
#Preview {
    ContactView(homeModel: HomeViewModel(), contactModel: ContactViewModel())
}
