//
//  SettingsView.swift
//  AINAO_Nav
//
//  Created by Apprenant 101 on 03/07/2024.
//

import SwiftUI

struct SettingsView: View {
    
    @State var userProfile : UserProfile
    @Binding var isEditingProfile : Bool
    @State private var showingLogoutAlert = false
    @State private var showingDeleteAccountAlert = false

    var body: some View {
        VStack {
            LinearGradient(
                gradient: Gradient(colors: [Theme.unbleach, Theme.color60]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            .overlay(
                VStack {
                    Spacer()
                    settingsOptions
                    Spacer()
                }
            )
        }
    }
    
    var settingsOptions: some View {
        VStack(spacing: 20) {
            Button(action: {
                showingLogoutAlert = true
            }) {
                Text("Se déconnecter")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .alert(isPresented: $showingLogoutAlert) {
                Alert(
                    title: Text("Déconnexion"),
                    message: Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
                    primaryButton: .destructive(Text("Déconnexion")) {
                        userProfile.userAccount.setSignInStatus(false)
                        isEditingProfile = false
                    },
                    secondaryButton: .cancel()
                )
            }

            Button(action: {
                showingDeleteAccountAlert = true
            }) {
                Text("Supprimer le compte")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)

            }
            .alert(isPresented: $showingDeleteAccountAlert) {
                Alert(
                    title: Text("Supprimer le compte"),
                    message: Text("Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible."),
                    primaryButton: .destructive(Text("Supprimer")) {
                        userProfile.userAccount.setInitializationStatus(false)
                        userProfile.userAccount.setSignInStatus(false)
                        isEditingProfile = false
                        Task {
                            await userProfile.userAccount.deleteUser()
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}


//
//#Preview {
//    struct PreviewWrapper: View {
//        @State var userProfile = UserProfile()
//                
//        var body: some View {
//            SettingsView(userProfile : userProfile, isEditingProfile: true)
//        }
//    }
//    return PreviewWrapper()
//}
