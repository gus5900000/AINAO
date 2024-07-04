//
//  RegistrationNextGenView.swift
//  AINAO_Nav
//
//  Created by FrancoisW on 01/07/2024.
//

import SwiftUI

// WARNING: CODE PAS OPTIMISE
// WARNING: CODE PAS OPTIMISE
// WARNING: CODE PAS OPTIMISE
// WARNING: CODE PAS OPTIMISE
// WARNING: CODE PAS OPTIMISE

struct RegistrationNextGenView:View {
    
    @Binding var userProfile : UserProfile // This is in fact an kind of @ObervedObject
    @Binding var isEditingProfile: Bool
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var userValid: Bool = false
    @State var userViewModel = UserData()
    @State private var goToRegistrationScreen = false
    
    var body: some View {
        
        VStack {
            ZStack {
                Image("BackgroundLoggin")
                    .blur(radius: 10)
                VStack {
                    Spacer().frame(height: 175)
                    Image("Ainao3")
                        .resizable()
                        .colorInvert()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 176, height: 127)
                    Spacer().frame(height: 40)
                    ZStack {
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width, height: 700)
                            .foregroundStyle(Theme.color60)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                        
                        ScrollView {
                            Spacer().frame(height: 40)
                            VStack(alignment: .leading) {
                                
                                Text("Pseudo")
                                    .padding()
                                
                                TextField("Entrez votre pseudo", text: $username)
                                    .padding()
                                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                    .disableAutocorrection(true)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Theme.color30, lineWidth: 1)
                                    )
                                    .padding(.horizontal)
                                
                                Text("Email")
                                    .padding()
                                
                                TextField("Entrez votre mail", text: $email)
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Theme.color30, lineWidth: 1)
                                    )
                                    .padding(.horizontal)
                                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                    .disableAutocorrection(true)
                                
                                Text("Password")
                                    .padding()
                                
                                SecureField("Entrez votre mot de passe", text: $password)
                                    .padding()
                                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                    .disableAutocorrection(true)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Theme.color30, lineWidth: 1)
                                    )
                                    .padding(.horizontal)
                                Button(action: {
                                    //
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
                                            let result = await userProfile.userAccount.createUser(id: userProfile.id, name: username, email: email, password: password)
                                            print("Registration result = \(result)")
                                            if result {
                                                
                                                /*
                                                 The user is initialized and thus signed in
                                                 */
                                                userProfile.userAccount.setInitializationStatus(true)
                                                userProfile.userAccount.setSignInStatus(true)
                                                
                                            }
                                            userValid = true // Déclanche la modale
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                                                userValid = false // Au bout de 1,25 secondes enleve la modale
                                                isEditingProfile = false
                                            }
                                        }
                                    }) {
                                        ButtonNext()
                                    }
                                    Spacer()
                                }
                            } // FIN SCROLLVIEW
                        }
                        .frame(width: UIScreen.main.bounds.width)
                    }
                }
            }
            .fullScreenCover(isPresented: $userValid) {
                ModaleLoggingView(isPresented: $userValid,text: "Bienvenue \(username), chez Ainao !")
            }
        }
    }
}
struct ButtonNext:View {
    var body: some View {
        Image(systemName: "arrowshape.right.circle")
            .resizable()
            .frame(width: 75, height: 75)
            .foregroundStyle(Theme.color30)
    }
}

struct RegistrationNextGenView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationNextGenView(userProfile: .constant(UserProfile()), isEditingProfile: .constant(true))
            .environment(\.colorScheme, .light)
    }
}

//
//#Preview {
//    RegistrationNextGenView(userProfile: UserProfile()  )
//}
//
