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
            Button("Request Contacts Access") {
                contactModel.requestAccess()
            }
            List {
                Section(header: Text("Contacts")) {
//                    ForEach(contactModel.contacts) { contact in
//                        Text(contact.name)
//                        Circle(contact.pfp)
//                    }
                }
            }
            .navigationTitle("Home")
        }
    }
    
}
