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
import Contacts

class ContactViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var contacts: [CNContact] = []
    @Published var accessGranted = false
    @Published var nextScreen: AppScreen = .contact

    func requestAccess() {
        requestContactsAccess { granted in
            DispatchQueue.main.async {
                self.accessGranted = granted
                if granted {
                    self.contacts = self.fetchContacts()
                }
            }
        }
    }
    
    func requestContactsAccess(completion: @escaping (Bool) -> Void) {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    completion(true)
                } else {
                    print("Contacts access denied: \(String(describing: error))")
                    completion(false)
                }
            }
        }
    }

    func fetchContacts() -> [CNContact] {
        let store = CNContactStore()
        var contacts: [CNContact] = []
        let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        do {
            try store.enumerateContacts(with: request) { contact, _ in
                contacts.append(contact)
            }
        } catch {
            print("Failed to fetch contacts: \(error)")
        }
        return contacts
    }
}
