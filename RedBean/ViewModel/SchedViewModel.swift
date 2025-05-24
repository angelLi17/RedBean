//
//  SchedViewModel.swift
//  RedBean
//
//  Created by Angel on 5/24/25.
//

import Foundation
import FirebaseFirestore

class SchedViewModel: ObservableObject {
    @Published var schedules: [Schedule] = []
    @State private var userID = ""
    private let userId: String

    private let db = Firestore.firestore()
    
    init(userId: String) {
        self.userId = userId
        fetchSchedules(userID: userId)
    }

    func fetchSchedules(for userId: String) {
        db.collection("users").document(userId).collection("schedules").getDocuments { snapshot, error in
            // Parse documents and assign to self.schedules
        }
    }
    
    func fetchSchedules() {
        isLoading = true
        db.collection("users").document(userId).collection("schedules")
            .getDocuments { snapshot, error in
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                self.schedules = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: Schedule.self)
                } ?? []
            }
    }
    
    

    func addSchedule(for userId: String, schedule: Schedule) {
        // Write new schedule to Firestore
    }

    func updateSchedule(for userId: String, schedule: Schedule) {
        // Update schedule in Firestore
    }
}
