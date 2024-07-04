////
////  ProgileLoginNextGen.swift
////  AINAO_Nav
////
////  Created by FrancoisW on 01/07/2024.
////
//
//
//import SwiftUI
//
//struct ProfileLoginNextGenView: View {
//    
//    @Binding var isPresented : Bool
//    @State var userProfile : UserProfile // This is in fact an kind of @ObervedObject
//    
//    var body: some View {
//        let _ = print("Entree dans ProfileLoginNextGenView")
//        
//        let _ = print("isInitialized = \(userProfile.userAccount.isInitialized)")
//        let _ = print("isSignedIn = \(userProfile.userAccount.isSignedIn)")
//
//        NavigationView {
//            ZStack {
//                Color(Theme.unbleach)
//                    .edgesIgnoringSafeArea(.all)
//                    .opacity(0.95)
//                
//                VStack {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 90)
//                            .fill(
//                                LinearGradient(
//                                    gradient: Gradient(colors: [Theme.unbleach, Theme.color60]),
//                                    startPoint: .topLeading,
//                                    endPoint: .bottomTrailing
//                                )
//                            )
//                            .frame(width: 170, height: 170)
//                            .shadow(radius: 10)
//                        userProfile.profileImage.image
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 160, height: 160)
//                            .clipShape(Circle())
//                    }
//                    Spacer().frame(height: 100)
//                    
//                    let _ = print("Initialized:\(userProfile.userAccount.isInitialized), SignedIn:\(userProfile.userAccount.isSignedIn)")
//                    
//                    VStack {
//                        if (!userProfile.userAccount.isInitialized){
//                            let _ = print("ProfileLoginNextGenView (User non Initialized)")
//                            CustomButton(title: "S'inscrire", backgroundColor: Theme.color60, destination: RegistrationNextGenView(userProfile : userProfile))
//                        }
//                        else if (!userProfile.userAccount.isSignedIn) {
//                            let _ = print("ProfileLoginNextGenView (Initialized but not signed in)")
//                            CustomButton(title: "Se connecter", backgroundColor: Theme.color30, destination: LoginNextGenView(userProfile:  userProfile))
//                        }
//                        else {
//                            let _ = print("ProfileLoginNextGenView (Initializeda and signed in)")
//                            CustomButton(title: "Se deconnecter", backgroundColor: Theme.color30, destination: LoginNextGenView(userProfile:  userProfile))
//                        }
//                        Spacer().frame(height: 75)
//                    }
//                }
//            }
//            .navigationBarTitle("")
//            .navigationBarHidden(true)
//        }
//    }
//}
//
//
//
//struct NonInitialized_Previews: PreviewProvider {
//    static var previews: some View {
//        @State var isPresented = true
//        let userProfile = UserProfile()
//        ProfileLoginNextGenView(isPresented : $isPresented, userProfile: userProfile)
//            .environment(\.colorScheme, .light)
//    }
//}
//struct NonSignedIn_Previews: PreviewProvider {
//    static var previews: some View {
//        // Initialize the UserAccount with the desired state
//        let userAccount = UserAccount(isInitialized: false, isSignedIn: false) // Set signedIn to true
//
//
//        // Initialize the UserProfile with the UserAccount
//        let userProfile = UserProfile(userAccount: userAccount)
//
//        // Return the ProfileLoginNextGenView with the UserProfile
//        ProfileLoginNextGenView(isPresented: .constant(true), userProfile: userProfile)
//            .environment(\.colorScheme, .light)
//    }
//}
//
//struct CustomButton<Destination: View>: View {
//    let title: String
//    let backgroundColor: Color
//    let destination: Destination
//    
//    var body: some View {
//        NavigationLink(destination: destination) {
//            Text(title)
//                .font(.title)
//                .fontWeight(.bold)
//                .opacity(0.8)
//                .foregroundColor(Theme.color10)
//                .frame(maxWidth: .infinity)
//                .padding(.vertical, 20)
//                .background(backgroundColor)
//                .cornerRadius(12)
//                .shadow(radius: 10)
//        }
//        .padding(.horizontal, 80)
//    }
//}
