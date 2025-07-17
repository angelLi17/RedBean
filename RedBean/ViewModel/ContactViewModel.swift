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
    @Published var nextScreen: AppScreen = .contact //not connected to homeview's screen variable
    
    @Published var selectedContactID: String? = nil
    @Published var selectedSchedule: Int? = nil
    @Published var selectedPhoto: Int? = nil
    
    @Published var builtInSchedules = [
        TimerSchedule(name: "Classic Pomodoro", workMinutes: 25, breakMinutes: 5),
        TimerSchedule(name: "Short Focus", workMinutes: 20, breakMinutes: 10),
        TimerSchedule(name: "Deep Work", workMinutes: 50, breakMinutes: 10)
    ]
    @Published var registeredContacts: [String: String] = [:] // [contact.identifier: uid]

    func checkAllContactsRegistration() {
        for contact in contacts {
            for phoneLabel in contact.phoneNumbers {
                let numberString = phoneLabel.value.stringValue
                checkIfPhoneNumberRegistered(numberString) { isRegistered, uid in
                    DispatchQueue.main.async {
                        if isRegistered, let uid = uid {
                            self.registeredContacts[contact.identifier] = uid
                        }
                    }
                }
            }
        }
    }

//     func fetchContacts() {
//         let store = CNContactStore()
//         store.requestAccess(for: .contacts) { granted, error in
//             guard granted else { return }
//             let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
//             let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
//             var tempContacts: [CNContact] = []
//             try? store.enumerateContacts(with: request) { contact, _ in
//                 if !contact.phoneNumbers.isEmpty {
//                     tempContacts.append(contact)
//                 }
//             }
//             DispatchQueue.main.async {
//                 self.contacts = tempContacts
//             }
//         }
//     }
    
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
    
    
    func checkIfPhoneNumberRegistered(_ phoneNumber: String, completion: @escaping (Bool, String?) -> Void) {
        let db = Firestore.firestore()
        db.collection("phoneToUID").document(phoneNumber).getDocument { snapshot, error in
            if let doc = snapshot, doc.exists, let data = doc.data(), let uid = data["uid"] as? String {
                completion(true, uid)
            } else {
                completion(false, nil)
            }
        }
    }
}
