//
//  CallView.swift
//  RedBean
//
//  Created by Angel on 7/11/25.
//

import SwiftUI

struct CallView: View {

    @ObservedObject var callModel: CallViewModel
    @ObservedObject var contactModel : ContactViewModel
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State private var workTime: Bool = true
    @State private var usePomodoroOrOtherDefault: Bool = true
    @State private var timerActive = false
    
    @State var timeRemaining: Int
    
    @State private var items: [ChecklistItem] = [
           //ChecklistItem(text: "First task", isChecked: false)
    ]
    
    @State private var newItemText: String = ""
    
    var body: some View {

        ZStack {
            Image("Bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .frame(width: screenWidth, height: screenHeight)
                .opacity(0.3)
            
            VStack(spacing: screenHeight/17) {
                //header
                headerView
                
                //three grids
                VStack(spacing: screenHeight/30) {
                    
                    //contacts
                    callView
                    
                    //schedule choice
                    timerView
                    
                    //photobooth
                    checklistView
                    
                }
                .frame(width: 9*screenWidth/11)
                //footer
                footerView

            }
        }
    }
    
    var headerView: some View {
        HStack(spacing: 70) {
            Text(contactModel.selectedContactID ?? "Unknown Caller")
                .font(.custom("Jua", size: 30))
                .foregroundColor(Color("aRed"))
        }
        .frame(width: screenWidth, height: screenHeight/20)
        .background{
            Color("aPink")
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.30), radius: 2, y: 4
            )
        }
    }
    
    var callView: some View {
        ZStack {
            Color("aPink")
                .cornerRadius(20)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 4, y: 4
                )
            Color(.white)
                .cornerRadius(10)
                .padding(screenWidth/10/3)
                .padding(.top, screenWidth/10/2)
            Text("choose a friend to call")
                .font(.custom("Biryani", size: 20))
                .padding(.bottom, 6*screenHeight/30)
                .foregroundColor(Color("aRed"))
            
            List(contactModel.contacts, id: \.identifier) { contact in
                Text("\(contact.givenName) \(contact.familyName)")
                    .font(.headline)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        contactModel.selectedContactID == contact.identifier
                        ? Color.gray.opacity(0.3)
                        : Color.clear
                    )
                    .contentShape(Rectangle()) // Makes the whole row tappable
                    .onTapGesture {
                        contactModel.selectedContactID = contact.identifier
                        // Do something else on tap if needed
                }
            }
            .cornerRadius(10)
            .padding(screenWidth/10/2)
            .padding(.top, screenWidth/10/3)
            .font(.custom("Biryani", size: 15))
            .frame(maxWidth: .infinity, alignment: .leading)
            .listStyle(.plain)
            .foregroundColor(Color("aRed"))
        }
        .frame(width: 9*screenWidth/11, height: screenHeight/4)
    }

    var timerView: some View {
        HStack {
            //red timer
            redTimerView
            
            Spacer(minLength: screenWidth/20)
            //custom time and session type scheduler block
            if usePomodoroOrOtherDefault {
                ZStack {
                    Color("aPink")
                        .cornerRadius(20)
//                        .shadow(
//                            color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 4, y: 4)
//                        .opacity(0.7)
                    Text("Tap to switch to custom time blocking scheduler.")
                        .font(.custom("Jua", size:18))
                        .foregroundColor(Color("aRed"))
                        .opacity(0.6)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .frame(width: 7*screenWidth/15, height: screenHeight/8)
                .onTapGesture {
                    usePomodoroOrOtherDefault=false
                }
            } else {
                customTimeBlock
            }
            
        }
    }

    var customTimeBlock: some View {
        VStack(spacing:8) {
            //select a session type
            HStack() {
                Text("work")
                    .font(.custom("Biryani", size: 20))
                    .foregroundColor(workTime ? Color.white : Color("aRed"))
                    .frame(width: 2*screenWidth/7, height: screenWidth/12)
                    .background(
                        (workTime ? Color("aRed") : Color.white)
                            .cornerRadius(10)
                    )
                    .onTapGesture {
                        workTime = true;//add smt so its only if a session time is selected AND ALSO MAKE usePomodoro false
                    }
                
                Text("break")
                    .font(.custom("Biryani", size: 20))
                    .foregroundColor(workTime ? Color("aRed") : Color.white)
                    .frame(width: 2*screenWidth/7, height: screenWidth/12)
                    .background(
                        (workTime ? Color.white : Color("aRed"))
                            .cornerRadius(10)
                    )
                    .onTapGesture {
                        workTime = false; //only if a session time is selected
                    }
            }
            
            HStack {
                Text("1) Select a time 2) Tap work/break. Custom path ends the default timer.")
                    .font(.custom("Biryani", size:10))
                    .lineSpacing(-8)
                    .padding(5)
                Picker("Session Length", selection: $callModel.customTime) {
                    ForEach(callModel.builtInTimes, id: \.self) { option in
                        Text(option)
                            .font(.custom("Biryani", size: 10))
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .foregroundColor(Color("aRed"))
                // Show a text field if "Other" is selected
                if callModel.customTime == "Other" {
                    TextField("Enter custom session (e.g., 40 min)", text: $callModel.otherTime)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.custom("Biryani", size: 10))
                }
            }
            .foregroundColor(Color("aRed"))
            .frame(width: 21*screenWidth/35, height: screenWidth/6)
            .background(
                Color.white
                    .cornerRadius(10)
            )
            
        }
        .frame(width: 7*screenWidth/10, height: screenHeight/6)
        .background{
            Color("aPink")
                .cornerRadius(20)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 4, y: 4)
        }
    }
    
    var redTimerView : some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                Circle()
                    .trim(from: 0, to: CGFloat(timeFraction))
                    .stroke(workTime ? Color("aRed") : Color.green, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.linear, value: timeRemaining)
                VStack {
                    Text(timeString)
                        .font(.custom("Biryani", size: 25))
                    Button(timerActive ? "pause" : "start") {
                        timerActive.toggle()
                    }
                        .foregroundStyle(Color("aRed"))
                        .font(.custom("Jua", size: 18))
                }
                
            }
            .frame(width: screenWidth/4, height: screenWidth/4)

            if !timerActive && timeRemaining == 0 {
                //sound
            }
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            guard timerActive, timeRemaining > 0 else { return }
            timeRemaining -= 1
            if timeRemaining == 0 {
                timerActive = false
                if usePomodoroOrOtherDefault {
                    // Switch between work and break
                    workTime.toggle()
                    timeRemaining = (workTime ? callModel.builtInSchedules[contactModel.selectedSchedule ?? 0].workMinutes : callModel.builtInSchedules[contactModel.selectedSchedule ?? 0].breakMinutes) * 60
                    timerActive = true
                }
            }
        }
    }
    
    private var timeFraction: Double {
        let total = (workTime ? callModel.builtInSchedules[contactModel.selectedSchedule ?? 0].workMinutes : callModel.builtInSchedules[contactModel.selectedSchedule ?? 0].breakMinutes) * 60
        return total == 0 ? 0 : Double(timeRemaining) / Double(total)
    }

    private var timeString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    var checklistView: some View {
        ZStack {
            Color("aPink")
                .cornerRadius(20)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 4, y: 4
                )
            Color(.white)
                .cornerRadius(10)
                .padding(screenWidth/10/3)
                .padding(.top, screenWidth/10/2)
            Text("to-do checklist")
                .font(.custom("Biryani", size: 20))
                .padding(.bottom, 6*screenHeight/40)
                .foregroundColor(Color("aRed"))
            
            VStack {
                ScrollView(.vertical) {
                    VStack(alignment: .leading) {
                        ForEach($items) { $item in
                            ScrollView(.horizontal) {
                                HStack {
                                    Button(action: { item.isChecked.toggle() }) {
                                        Image(systemName: item.isChecked ? "checkmark.square" : "square")
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    TextField("To-do", text: $item.text)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .frame(minWidth: 200, maxWidth: .infinity)
                                }
                                .padding(.vertical, 2)
                            }
                            .frame(height: 40) // Keeps each row a consistent height
                        }
                    }
                }
                HStack {
                    TextField("Add new task", text: $newItemText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Add") {
                        if !newItemText.isEmpty {
                            items.append(ChecklistItem(text: newItemText, isChecked: false))
                            newItemText = ""
                        }
                    }
                }
            }
            .cornerRadius(10)
            .padding(screenWidth/10/2)
            .padding(.top, screenWidth/10/3)
            .font(.custom("Biryani", size: 15))
            .frame(maxWidth: .infinity, alignment: .leading)
            .listStyle(.plain)
            .foregroundColor(Color("aRed"))
            .contentShape(Rectangle())
        }
        .frame(width: 9*screenWidth/11, height: screenHeight/5)
    }
    
    var footerView: some View {
        HStack(spacing:screenWidth/22) {
            Rectangle()
                .frame(width:screenWidth/7, height:screenHeight/22)
                .foregroundColor(Color("aPink"))
                .cornerRadius(10)
            Text("End Bean")
                .foregroundColor(Color.white)
                .font(.custom("Biryani", size: 20))
                .frame(width:3*screenWidth/7, height:screenHeight/22)
                .background(Color("aRed"))
                .onTapGesture {
                    contactModel.nextScreen = .photo
                }
            Rectangle()
                .frame(width:screenWidth/7, height:screenHeight/22)
                .foregroundColor(Color("aPink"))
                .cornerRadius(10)
        }
    }
}
#Preview {
    CallView(callModel: CallViewModel(), contactModel: ContactViewModel(), timeRemaining: 25)
}
