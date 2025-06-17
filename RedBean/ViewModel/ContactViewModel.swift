//
//  MainAppViewModel.swift
//  RedBean
//
//  Created by Angel on 5/18/25.
//

import SwiftUI
import Foundation
import Combine
import FirebaseFirestore

class ContactsViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var contacts: [CNContact] = []
    @Published var accessGranted = false

    private let userId: String


    func requestAccess() {
        requestContactsAccess { granted in
            DispatchQueue.main.async {
                self.accessGranted = granted
                if granted {
                    self.contacts = fetchContacts()
                }
            }
        }
    }
}
