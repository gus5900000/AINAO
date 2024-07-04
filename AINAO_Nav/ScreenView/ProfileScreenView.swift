//
//  ProfileScreenView.swift
//  EatSideStory
//
//  Created by FrancoisW on 20/06/2024.
//

import SwiftUI
import PhotosUI

import SwiftUI
import UIKit
import PhotosUI

struct ProfileScreenView: View {
    
    
    @Binding var userProfile : UserProfile // This is in fact an kind of @ObervedObject
    @Binding var isEditingProfile : Bool // Track whether the profile sheet is open
    @State var isLoginView: Bool = false
    @State  private var     photoPickerItem : PhotosPickerItem?
    @State private var tempName: String = ""
    
    
    var body: some View {
        NavigationView {
            
            ZStack{
                LinearGradient(
                    gradient: Gradient(colors: [Theme.unbleach, Theme.color60]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    ZStack {
                        
                        VStack(alignment: .center, spacing: 0.0) {
                            /***
                             Carton Principal (Clint et son plamares)
                             */
                            
                            ZStack{
                                
                                RoundedRectangle(cornerRadius: Consts.UI.cornerRadiusFrame)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                                    .padding(.bottom, -25)
                                
                                    .foregroundStyle(Theme.frame)
                                    .opacity(0.5)
                                    .edgesIgnoringSafeArea(.all) // Add this line if you want the RoundedRectangle to extend to the screen edges
                                VStack {
                                    
                                    HStack {
                                        Spacer()
                                        
                                        NavigationLink(destination: SettingsView(userProfile: userProfile, isEditingProfile: $isEditingProfile)) {
                                            Image(systemName: "gearshape.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 50)
                                                .foregroundColor(Theme.appleGrey) // Notez que j'ai changé 'foregroundStyle' en 'foregroundColor'
                                                .opacity(0.8)
                                                .padding()
                                        }
                                        
                                        /*
                                         Button(action: {
                                         // Action à effectuer lorsque le bouton est pressé
                                         userProfile.userAccount.setSignInStatus(false)
                                         isEditingProfile = false
                                         }) {
                                         Image(systemName: "gearshape.fill")
                                         .resizable()
                                         .scaledToFit()
                                         .frame(height: 50)
                                         .foregroundStyle(Theme.appleGrey)
                                         .opacity(0.8)
                                         .padding()
                                         }
                                         */
                                    }
                                    Spacer()
                                }
                                
                                
                                VStack(alignment: .center) {
                                    // Image + Pencil
                                    
                                    HStack(spacing:0) {
                                        CircleImageView(image : userProfile.profileImage.image, size : 150)
                                        
                                        PencilView(photoPickerItem: $photoPickerItem, size : 9)
                                            .padding(.top, -55)
                                            .padding(.horizontal, -50)
                                        Spacer()
                                    }
                                    
                                    // Name
                                    ZStack {
                                        TextField("Enter name", text: $tempName)
                                            .onAppear {
                                                tempName = userProfile.userAccount.name ?? ""
                                            }
                                            .onChange(of: tempName) { newValue in
                                                // Update the userAccount.name whenever the temporary state changes
                                                userProfile.userAccount.setName(newValue)
                                            }
                                        
                                            .padding(.leading, -100.0)
                                            .multilineTextAlignment(.center)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .frame(width : 70)
                                            .padding(.bottom, 9.0)
                                            .padding(.top, -20.0)
                                        
                                        
                                    }
                                    // Badge set
                                    HStack(alignment: .top) {
                                        VStack{
                                            Text("Badges")
                                                .fontWeight(.bold)
                                            HStack {
                                                Image("iconsBadge1")
                                                    .resizable()
                                                    .frame(width: 30, height: 30)
                                                Image("iconsShérif")
                                                    .resizable()
                                                    .frame(width: 30, height: 30)
                                            }
                                            
                                            HStack {
                                                Image("iconsTroisiemePlace")
                                                    .resizable()
                                                    .frame(width: 30, height: 30)
                                                //     We remove one Icon(inserting image with wrong name
                                                Image("iconsDeuxiemePlace")
                                                //Image("iconsDeuxiemePlace?")
                                                    .resizable()
                                                    .frame(width: 30, height: 30)
                                            }
                                        }
                                        Spacer()
                                        // SCORES
                                        
                                        VStack(alignment: .leading) {
                                            Text("Points")
                                                .fontWeight(.bold)
                                                .padding(.bottom, 0)
                                            
                                            Text("\(userProfile.points) points")
                                            
                                        }
                                        
                                    }
                                    
                                    .padding(.trailing, 30)
                                    .padding(.leading, -70)
                                }
                                .padding(.top, -100)
                                .padding(/*@START_MENU_TOKEN@*/.leading, 100)
                                VStack{
                                    Spacer()
                                    HStack {
                                        ButtonProfile(title: "Critère")
                                        ButtonProfile(title: "POT")
                                    }
                                }
                            }
                            
                            .padding(.top, -150)
                            .frame(width : 355, height : 300)
                            .padding(.bottom, 60.0)
                            
                            
                            Spacer()
                            
                            VStack {
                                // Bouton pour rediriger vers ProfilLoginView
                                Button(action: {
                                    // When the user
                                    userProfile.userAccount.setSignInStatus(false)
                                    isLoginView.toggle()
                                }) {
                                }
                            }
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                            //                        .fullScreenCover(isPresented: $isLoginView) {
                            //                            ProfileEntranceView(isPresented: $isLoginView, isEditingProfile: , userProfile: $userProfile)
                            //                        }
                            
                            Spacer()
                            
                            Button(action: {
                                isEditingProfile = false
                                
                            }) {
                                Text(Consts.UI.doneButtonName) // This is the label for your button.
                                    .bold()
                                    .foregroundStyle(Theme.color60)
                                    .frame(width: 280,height:50)
                                    .background(Theme.color30)
                                    .cornerRadius(Consts.UI.cornerRadiusButton)
                            }
                            
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding(.top)
                }
                .padding(.top, 229)
            }
            .task(id: photoPickerItem) {
                if let item = photoPickerItem {
                    do {
                        let data = try await item.loadTransferable(type: Data.self)
                        userProfile.profileImage.updateFromPhotoPicker(data: data)
                    } catch {
                        // Handle errors here
                        print("Error loading image: \(error)")
                    }
                }
            }
        }
        
    }
    
    #Preview {
        struct PreviewWrapper: View {
            @State var userProfile = UserProfile()
            
            @State var isEditingProfile = false
            
            var body: some View {
                ProfileScreenView(userProfile : $userProfile,  isEditingProfile : $isEditingProfile)
            }
        }
        return PreviewWrapper()
    }
    
    struct PencilView: View {
        @Binding var photoPickerItem : PhotosPickerItem?
        
        var size : Double = 30
        var body: some View {
            ZStack{
                PencilIconView(size : size)
                
                PhotosPicker("            ",
                             selection: $photoPickerItem,
                             matching: .images)
            }
        }
    }
    
    struct PencilIconView: View {
        var size : Double = 30
        
        var body: some View {
            ZStack{
                Circle()
                    .fill(Theme.color30)
                    .frame(width: size*2, height: size*2) // 20% of the size of the image
                
                Image(systemName:  "pencil")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size) // Specify your desired dimensions here
                    .foregroundColor(.white)
            }
        }
    }
    
    struct ButtonProfile: View {
        
        let title: String
        
        var body: some View {
            VStack {
                Button(action: {
                    //action
                }) {
                    RoundedRectangle(cornerRadius: Consts.UI.cornerRadiusButton)
                        .frame(width: 150, height: 100)
                        .foregroundColor(Theme.unbleach)
                        .opacity(0.8)
                    
                        .overlay(
                            Text(title)
                                .foregroundColor(.black)
                                .opacity(0.6)
                                .bold()
                        )
                }
            }
        }
    }
}
