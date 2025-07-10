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
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State private var selectedContactID: String? = nil
    
    var body: some View {
        GeometryReader { geometry in
            Image("Bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .frame(width: geometry.size.width, height: geometry.size.height)
            
            ZStack {
                VStack(spacing: 20) {
                    
                    //header
                    headerView
                    
                    //three grids
                    VStack(spacing: geometry.size.height/8) {
                        
                        //contacts
                        contactView
                        
                        //schedule choice
                        scheduleView
                        
                        //photobooth
                        photoView
                        
                    }
                    
                    //footer
                    footerView
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
    
    var headerView: some View {
        HStack(spacing: 70) {
            Text("Start a Bean")
                .font(.custom("Jua", size: 30))
                .foregroundColor(Color("aRed"))
            Image("HomeIcon")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
        }
        .frame(width: 427, height: 50)
        .opacity(0.9)
        .background{
            Color("aPink")
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.30), radius: 2, y: 4
            )
        }
    }
    
    var contactView: some View {
        ZStack {
            Color("aPink")
                .cornerRadius(20)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.7), radius: 4, y: 4
                )
            Color(.white)
                .cornerRadius(10)
                .padding(screenWidth/10/2)
                .padding(.top, screenWidth/10/4)
            Text("choose a friend to call")
                .font(.custom("Biryani", size: 15))
                .padding(.bottom, 19*screenWidth/10/4)
                .foregroundColor(Color("aRed"))
            
            List(contactModel.contacts, id: \.identifier) { contact in
                Text("\(contact.givenName) \(contact.familyName)")
                    .font(.headline)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        selectedContactID == contact.identifier
                        ? Color.gray.opacity(0.3)
                        : Color.clear
                    )
                    .contentShape(Rectangle()) // Makes the whole row tappable
                    .onTapGesture {
                        selectedContactID = contact.identifier
                        // Do something else on tap if needed
                    }
            }
            
            .frame(width: 9*screenWidth/10, height: screenHeight/5)
        }
    }

    var scheduleView: some View {
        Color(.white)
            .cornerRadius(10)
            .padding(screenWidth/10/2)
            .padding(.top, screenWidth/10/4)
            .frame(width: 9*screenWidth/10, height: screenHeight/5)
    }
    
    var photoView: some View {
        Color(.white)
            .cornerRadius(10)
            .padding(screenWidth/10/2)
            .padding(.top, screenWidth/10/4)
            .frame(width: 9*screenWidth/10, height: screenHeight/5)
    }
    
    var footerView: some View {
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
}
#Preview {
    ContactView(homeModel: HomeViewModel(), contactModel: ContactViewModel())
}
