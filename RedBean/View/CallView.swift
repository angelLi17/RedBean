//
//  CallView.swift
//  RedBean
//
//  Created by Angel on 7/11/25.
//

import SwiftUI
import StreamVideo
import StreamVideoSwiftUI

struct CallView: View {

    @ObservedObject var callModel: CallViewModel
    @ObservedObject var contactModel : ContactViewModel
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @State private var workTime: Bool = true
    @State private var usePomodoroOrOtherDefault: Bool = true
    @State private var timerActive = false
    
    @State private var timeRemaining: Int

    init(callModel: CallViewModel, contactModel: ContactViewModel) {
        self.callModel = callModel
        self.contactModel = contactModel
        let schedule = Self.schedule(callModel: callModel, contactModel: contactModel)
        _timeRemaining = State(initialValue: schedule.workMinutes * 60)
    }

    /// The schedule picked on the Start a Bean screen (its rows are numbered 1...3).
    private static func schedule(callModel: CallViewModel, contactModel: ContactViewModel) -> TimerSchedule {
        let index = (contactModel.selectedSchedule ?? 1) - 1
        let safeIndex = min(max(index, 0), callModel.builtInSchedules.count - 1)
        return callModel.builtInSchedules[safeIndex]
    }

    private var schedule: TimerSchedule {
        Self.schedule(callModel: callModel, contactModel: contactModel)
    }
    
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
        .task {
            if let friend = contactModel.selectedFriend {
                await callModel.startBean(friendUID: friend.uid)
            }
        }
        .onDisappear {
            callModel.leaveCall()
        }
    }
    
    var headerView: some View {
        HStack(spacing: 70) {
            Text(contactModel.selectedFriend?.name ?? "Unknown Caller")
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
            GeometryReader { geo in
                ZStack {
                    remoteVideo(size: geo.size)

                    if let me = callModel.localParticipant {
                        VideoCallParticipantView(
                            viewFactory: DefaultViewFactory.shared,
                            participant: me,
                            id: "\(me.id)-local",
                            availableFrame: CGRect(x: 0, y: 0, width: geo.size.width / 3.5, height: geo.size.height / 2),
                            contentMode: .scaleAspectFill,
                            customData: ["videoOn": .bool(callModel.cameraOn)],
                            call: callModel.call
                        )
                        .frame(width: geo.size.width / 3.5, height: geo.size.height / 2)
                        .cornerRadius(8)
                        .clipped()
                        .padding(6)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    }

                    callControls
                        .padding(6)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                }
            }
            .background(Color.white)
            .cornerRadius(10)
            .clipped()
            .padding(screenWidth/10/3)
        }
        .frame(width: 9*screenWidth/11, height: screenHeight/4)
    }

    @ViewBuilder
    private func remoteVideo(size: CGSize) -> some View {
        if let friend = callModel.remoteParticipant {
            VideoCallParticipantView(
                viewFactory: DefaultViewFactory.shared,
                participant: friend,
                availableFrame: CGRect(origin: .zero, size: size),
                contentMode: .scaleAspectFill,
                customData: [:],
                call: callModel.call
            )
            .frame(width: size.width, height: size.height)
        } else {
            VStack(spacing: 8) {
                Text(statusText)
                    .font(.custom("Biryani", size: 16))
                    .foregroundColor(Color("aRed"))
                    .multilineTextAlignment(.center)
                if case .failed = callModel.callStatus, let friend = contactModel.selectedFriend {
                    Button("try again") {
                        Task { await callModel.startBean(friendUID: friend.uid) }
                    }
                    .font(.custom("Jua", size: 18))
                    .foregroundStyle(Color("aRed"))
                }
            }
            .padding()
            .frame(width: size.width, height: size.height)
        }
    }

    private var statusText: String {
        let name = contactModel.selectedFriend?.name ?? "your friend"
        switch callModel.callStatus {
        case .idle, .connecting: return "connecting..."
        case .waitingForFriend: return "waiting for \(name) to start a bean with you"
        case .inCall: return ""
        case .failed(let message): return "couldn't connect: \(message)"
        }
    }

    private var callControls: some View {
        HStack(spacing: 10) {
            controlButton(callModel.micOn ? "mic.fill" : "mic.slash.fill", action: callModel.toggleMic)
            controlButton(callModel.cameraOn ? "video.fill" : "video.slash.fill", action: callModel.toggleCamera)
            controlButton("arrow.triangle.2.circlepath.camera", action: callModel.flipCamera)
        }
        .opacity(callModel.call == nil ? 0 : 1)
    }

    private func controlButton(_ systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(Color("aRed").opacity(0.85))
                .clipShape(Circle())
        }
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
                    timeRemaining = (workTime ? schedule.workMinutes : schedule.breakMinutes) * 60
                    timerActive = true
                }
            }
        }
    }
    
    private var timeFraction: Double {
        let total = (workTime ? schedule.workMinutes : schedule.breakMinutes) * 60
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
                    callModel.endBean()
                }
            Rectangle()
                .frame(width:screenWidth/7, height:screenHeight/22)
                .foregroundColor(Color("aPink"))
                .cornerRadius(10)
        }
    }
}
#Preview {
    CallView(callModel: CallViewModel(), contactModel: ContactViewModel())
}
