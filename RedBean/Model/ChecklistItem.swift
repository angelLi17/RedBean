//
//  ChecklistItem.swift
//  RedBean
//
//  Created by Angel on 7/12/25.
//

import Foundation


struct ChecklistItem: Identifiable {
    let id = UUID()
    var text: String
    var isChecked: Bool
}
