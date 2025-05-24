//
//  Contacts.swift
//  RedBean
//
//  Created by Angel on 5/24/25.
//

let db = Firestore.firestore()
db.collection("users").document(user.uid).setData([
    "name": user.displayName,
    "email": user.email,
    // ...other fields
])
