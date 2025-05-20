//
//  MainAppViewModel.swift
//  RedBean
//
//  Created by Angel on 5/18/25.
//

import SwiftUI
import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?

    
}
