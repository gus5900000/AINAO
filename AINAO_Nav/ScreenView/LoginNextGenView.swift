//
//  LoginViewNextGen.swift
//  AINAO_Nav
//
//  Created by FrancoisW on 01/07/2024.
//


import SwiftUI

struct LoginNextGenView: View {
    
    
    @Binding var userProfile : UserProfile // This is in fact an kind of @ObervedObject
    @Binding var isEditingProfile: Bool
    
    
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var userValid: Bool = false
    @State var userViewModel = UserData()
    
    @State private var showingModal = false
    @State private var messageText = ""
    
    var body: some View {
        
        VStack {
            ZStack {
                Image("BackgroundLoggin")
                    .blur(radius: 10)
                VStack {
                    Spacer().frame(height: 200)
                    Image("Ainao3")
                        .resizable()
                        .colorInvert()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 176, height: 127)
                    Spacer().frame(height: 50)
                    ZStack {
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width, height: 600)
                            .foregroundStyle(Theme.color60)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                        
                        ScrollView {
                            Spacer().frame(height: 50)
                            VStack(alignment: .leading) {
                                
                                Text("E-Mail")
                                    .padding()
                                
                                TextField("Entrez votre email", text: $email)
                                    .padding()
                                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                    .disableAutocorrection(true)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Theme.color30, lineWidth: 1)
                                    )
                                    .padding(.horizontal)
                                
                                
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
                                    isEditingProfile = false 
                                    userProfile.userAccount.setSignInStatus(true)

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
                                            userValid = await userProfile.userAccount.verifyUser(email: email, password: password,userProfile: userProfile)
                                            
                                            if userValid {
                                                // The user is initialized and thus signed in
                                                userProfile.userAccount.setSignInStatus(true)
                                                
                                                // Show transient modal view for successful login
                                                showingModal = true
                                                messageText = "Login Successful"
                                            } else {
                                                // Show transient modal view for failed login
                                                showingModal = true
                                                messageText = "Login Failed"
                                            }
                                            
                                            // Dismiss the modal view after 1 second
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                userValid = false
                                                showingModal = false
                                                isEditingProfile = false
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
                        } // FIN SCROLL VIEW
                        .frame(width: UIScreen.main.bounds.width)
                    }
                }
            }
            .fullScreenCover(isPresented: $userValid) {
                ModaleLoggingView(isPresented: $userValid, text: "Salut \(String(describing: userProfile.userAccount.name!)), content de te revoir !")
            }
        }
    }
}

struct LoginNextGenView_Previews: PreviewProvider {
    static var previews: some View {
        LoginNextGenView(userProfile: .constant(UserProfile()), isEditingProfile: .constant(true))
            .environment(\.colorScheme, .light)
    }
}
//
//#Preview {
//    LoginNextGenView(userProfile: UserProfile(), isEditingProfile: .constant(true))
//}
