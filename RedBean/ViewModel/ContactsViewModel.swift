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
    private let db = Firestore.firestore()
    private let userId: String

    init(userId: String) {
        self.userId = userId
        fetchContacts()
    }
    
    
    func fetchContacts() {
//        db.collection("users").document(userId).collection("contacts")
//            .getDocuments { snapshot, error in
//                if let error = error {
//                    self.errorMessage = error.localizedDescription
//                    return
//                }
//                self.contacts = snapshot?.documents.compactMap { doc in
//                    try? doc.data(as: Contact.self)
//                } ?? []
//            }
    }
}
