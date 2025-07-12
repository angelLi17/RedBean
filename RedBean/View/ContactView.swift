//
//  ContactView.swift
//  RedBean
//
//  Created by Angel on 5/24/25.
//

import SwiftUI

struct ContactView: View {
    @ObservedObject var homeModel: HomeViewModel
    @ObservedObject var contactModel : ContactViewModel
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {

        ZStack {
            Image("Bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .frame(width: screenWidth, height: screenHeight)
            
            VStack(spacing: screenHeight/17) {
                //header
                headerView
                
                //three grids
                VStack(spacing: screenHeight/30) {
                    
                    //contacts
                    contactView
                    
                    //schedule choice
                    scheduleView
                    
                    //photobooth
                    photoView
                    
                }
            
                //footer
                footerView
            }
        }
    }
    
    var headerView: some View {
        HStack(spacing: 70) {
            Text("Start a Bean")
                .font(.custom("Jua", size: 30))
                .foregroundColor(Color("aRed"))
            Image("HomeIcon")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .onTapGesture {
                    contactModel.nextScreen = .home
                }
        }
        .frame(width: screenWidth, height: screenHeight/20)
        .opacity(0.9)
        .background{
            Color("aPink")
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.30), radius: 2, y: 4
            )
        }
    }
    
    var contactView: some View { //future=add scroll list for custom schedules adding
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
                .padding(.bottom, 6*screenHeight/40)
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
        .frame(width: 9*screenWidth/11, height: screenHeight/5)
    }

    var scheduleView: some View {
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
            Text("choose a work:break schedule")
                .font(.custom("Biryani", size: 20))
                .padding(.bottom, 6*screenHeight/40)
                .foregroundColor(Color("aRed"))
            
            List {
                Text("Classic Pomo-dango—25:5")
                    .background(
                        contactModel.selectedSchedule==1
                        ? Color.gray.opacity(0.3)
                        : Color.clear
                    )
                    .onTapGesture {
                        contactModel.selectedSchedule=1
                        // Do something else on tap if needed
                    }
                Text("Balanced Daifuku—20:10")
                    .background(
                        contactModel.selectedSchedule==2
                        ? Color.gray.opacity(0.3)
                        : Color.clear
                    )
                    .onTapGesture {
                        contactModel.selectedSchedule=2
                        // Do something else on tap if needed
                    }
                Text("Academic Injeolmi—50:10")
                    .background(
                        contactModel.selectedSchedule==3
                        ? Color.gray.opacity(0.3)
                        : Color.clear
                    )
                    .onTapGesture {
                        contactModel.selectedSchedule=3
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
            .contentShape(Rectangle())
        }
        .frame(width: 9*screenWidth/11, height: screenHeight/5)
    }
    
    var photoView: some View {
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
            Text("choose a photobooth theme")
                .font(.custom("Biryani", size: 20))
                .padding(.bottom, 6*screenHeight/40)
                .foregroundColor(Color("aRed"))
            
            List {
                Text("Mr. Diligent Red Bean")
                    .background(
                        contactModel.selectedPhoto==1
                        ? Color.gray.opacity(0.3)
                        : Color.clear
                    )
                    .onTapGesture {
                        contactModel.selectedPhoto=1
                        // Do something else on tap if needed
                    }
                //coming soon: Mrs. Classy Vanilla Bean, Sleepy Mung Bean Baby, Ms. Capricious Chickpea, Sir Benign Black Bean
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
            Text("START")
                .foregroundColor(Color.white)
                .font(.custom("Biryani", size: 20))
                .frame(width:3*screenWidth/7, height:screenHeight/22)
                .background{
                    (contactModel.selectedContactID != nil && contactModel.selectedSchedule != nil && contactModel.selectedPhoto != nil) ? Color("aRed") : Color.gray.opacity(0.3)
                }
                .onTapGesture {
                    if (contactModel.selectedContactID != nil && contactModel.selectedSchedule != nil && contactModel.selectedPhoto != nil) {
                        contactModel.nextScreen = .call
                    }
                }
            Rectangle()
                .frame(width:screenWidth/7, height:screenHeight/22)
                .foregroundColor(Color("aPink"))
                .cornerRadius(10)
        }
    }
}
#Preview {
    ContactView(homeModel: HomeViewModel(), contactModel: ContactViewModel())
}
