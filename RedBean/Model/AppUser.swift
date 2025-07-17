//
//  AppUser.swift
//  RedBean
//
//  Created by Angel on 7/16/25.
//

struct AppUser: Identifiable {
    let id: String      // Firebase UID, also used for Stream user id
    var name: String?   // Firebase displayName
    var imageURL: String? // Firebase photoURL
    var phonenum: String?
}
