//
//  TestView.swift
//  AINAO_Nav
//
//  Created by Apprenant 101 on 25/06/2024.
//

/*
import SwiftUI

struct TestView: View {
    
    @StateObject var userViewModel = UserData()
    // var id: String = "recuH0I25XrW5r9Wv"
    var id: String = "recfDxSdzeDQ3AFrB"
    
    var body: some View {
        VStack {
            if let userProfile = userViewModel.userProfilModel {
                List([userProfile.fields]) { user in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(user.username)
                                .foregroundColor(.primary) // Replace with Theme.color30 if defined
                            Text(user.mail)
                        }
                    }
                }
            } else {
                Text("Aucun utilisateur trouvé")
            }
            
            Button("Ajouter un enregistrement") {
                Task {
                    //await userViewModel.addUserModel(id: id)
                    let _ = print("Bouton appuyé")
                }
            }
        }
        .padding()
    }
}

struct TestCriteriaModel: View {
    
    @StateObject var userViewModel = UserData()
    @StateObject var criteriaViewModel = CriteriaData()
    var id: String = "recuH0I25XrW5r9Wv"

    
    var body: some View {
        VStack {
            if let criteria = criteriaViewModel.criteriaModel {
                List([criteria.fields]) { criterias in
                    HStack {
                        VStack(alignment: .leading) {
                            if criterias.stair == true {
                                Text("Escalier")
                            } else {
                                Text("Pas d'escalier")
                            }
                            if criterias.step == true {
                                Text("Marche")
                            } else {
                                Text("Pas de marche")
                            }
                        }
                    }
                }
            } else {
                Text("Aucun utilisateur trouvé")
            }
            
            Button("Ajouter un enregistrement") {
                Task {
                    let _ = print("Étape 1\n\n\n")
                    let _ = await userViewModel.addUserModel(id: id)
                    let _ = print("Étape 2\n\n\n")
                    let user = userViewModel.userProfilModel
                    let _ = print("Étape 3\n\n\n")
                    if let criteriaIDs = user?.fields.criteria {
                        let _ = print("Étape 4\n\n\n")
                        for criteriaID in criteriaIDs {
                            await criteriaViewModel.addUserModel(id: criteriaID)
                        }
                        let _ = print("Bouton appuyé")
                    } else {
                        print("Aucun critère trouvé")
                    }
                }
            }
        }
        .padding()
    }
}


struct TestProfil: View {
    
    @State var isPresented: Bool = false
    
    var body: some View {
        VStack {
            // Bouton pour rediriger vers ProfilLoginView
            Button(action: {
                isPresented.toggle()
            }) {
                Text("Go to Profil Login")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $isPresented) {
            ProfilLoginView1(isPresented: $isPresented)
        }
    }
}
    
struct TestPOT: View {
    
    @State var isPresented: Bool = false
    
    var body: some View {
        VStack {
            // Bouton pour rediriger vers ProfilLoginView
            Button(action: {
                isPresented.toggle()
            }) {
                Text("Go to Profil POT")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .sheet(isPresented: $isPresented) {
            POTAddView(isPresented: $isPresented)
        }
    }
}
    
//#Preview {
//    TestPOT()
//}


#Preview {
    TestProfil()
}

//
//#Preview {
//    TestView()
//}
//#Preview {
//    TestCriteriaModel()
//}
*/
