//
//  ScheduleView.swift
//  RedBean
//
//  Created by Angel on 5/24/25.
//

import SwiftUI

struct PhotoView: View {
    @ObservedObject var photoModel: PhotoViewModel
    //no custom saved sched option for now
    
    var body: some View {
        ZStack {

            List {
                Section(header: Text("Schedules")) {
//                    ForEach(contactModel.schedules) { schedule in
//                        Text(schedule.title)
                    
                }
            }
        }
    }
}
#Preview {
//    ContactView(homeModel: .init(userID: "", nextScreen: .home))
}
