//
//  LogInViewNew.swift
//  AINAO_Nav
//
//  Created by FrancoisW on 01/07/2024.
//

import SwiftUI



import SwiftUI

struct LogInViewNew: View {
    @State var userProfile : UserProfile
    
    
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var userValid: Bool = false
    @State var userViewModel = UserData()
    
    var body: some View {
        
        VStack {
            ZStack {
                Image("BackgroundLoggin")
                    .blur(radius: 10)
                VStack {
                    Spacer()
                    Image("AINAOLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 176, height: 127)
                    Spacer().frame(height: 50)
                    ZStack {
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width, height: 600)
                            .foregroundStyle(Theme.color60)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                        
                        VStack(alignment: .leading) {
                            
                            Text("E-Mail")
                                .padding()
                            
                            TextField("Entrez votre email", text: $email)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Theme.color30, lineWidth: 1)
                                )
                                .padding(.horizontal)
                            
                            
                            Text("Password")
                                .padding()
                            
                            SecureField("Entrez votre mot de passe", text: $password)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Theme.color30, lineWidth: 1)
                                )
                                .padding(.horizontal)
                            Button(action: {
//                                userViewModel.getRecordAirTable()
                            }) {
                                Text("Mot de passe oublié ?")
                                    .padding()
                                    .foregroundStyle(Theme.color30)
                                    .underline()
                            }
                            HStack {
                                Spacer()
                                Button(action: {
                                    Task {
                                        userValid = ((await userViewModel.checkLogging(email: email, password: password)) != nil)
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
                                Spacer()
                            }
                            
                            Spacer().frame(height: 125)
                            
                        }
                        .frame(width: UIScreen.main.bounds.width)
                    }
                }
            }
            .fullScreenCover(isPresented: $userValid) {
                ModaleLoggingView(isPresented: $userValid, text: "Salut \(email), content de te revoir !")
            }
        }
    }
}

#Preview {
    
    LogInViewNew(userProfile: UserProfile())

}

