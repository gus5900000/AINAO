//
//  RegistrationScreenOptionView.swift
//  AINAO_Nav
//
//  Created by Apprenant 101 on 28/06/2024.
//

import SwiftUI

struct RegistrationScreenOptionView: View {
    
    @State private var userValid: Bool = false
    @State var userViewModel = UserData()
    let username: String
    let email: String
    let password: String
    
    var body: some View {
        ZStack {
            Color(Theme.color60)
            VStack {
                Text("Photo de profil")
                    .font(.title2)
                    .bold()
                
                Image(systemName: "photo.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .foregroundColor(Theme.color30)
                    .padding()
                
                Text("Critères")
                    .font(.title2)
                    .bold()
                    .padding()
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Theme.frame)
                        .frame(width: 350, height: 200)
                        .shadow(radius: Consts.UI.shadowRadius)
                        .opacity(0.3)
                    
                    //AJOUT DES CRITERES
                }
                Spacer().frame(height: 100)
                VStack {
                    Button(action: {
                        Task {
                            userValid = ((await userViewModel.addUserData(id: UUID(), username: username, mail: email, password: password)) != nil)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                                userValid = false
                            }
                        }
                    }) {
                        Image(systemName: "arrowshape.right.circle")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundStyle(Theme.color30)
                    }
                }
                .fullScreenCover(isPresented: $userValid) {
                    ModaleLoggingView(isPresented: $userValid,text: "Salut \(email), content de te revoir !")
                }
            }
        }
        
        .ignoresSafeArea()
    }
}

#Preview {
    RegistrationScreenOptionView(username: "test", email: "test", password: "test")
}
