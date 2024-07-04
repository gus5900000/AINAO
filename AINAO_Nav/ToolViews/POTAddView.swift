//
//  POTAddView.swift
//  AINAO_Nav
//
//  Created by Apprenant 101 on 28/06/2024.
//

import SwiftUI

struct POTAddView: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color(Theme.unbleach)
            VStack {
                Text("POT")
                    .padding()
                HStack {
                    POTButtonView(image: "arrow.up", texte: "Haut")
                    POTButtonView(image: "arrow.up", texte: "Haut")
                    POTButtonView(image: "arrow.up", texte: "Haut")
                }
                HStack {
                    POTButtonView(image: "arrow.up", texte: "Haut")
                    POTButtonView(image: "arrow.up", texte: "Haut")
                    POTButtonView(image: "arrow.up", texte: "Haut")
                }
                HStack {
                    POTButtonView(image: "arrow.up", texte: "Haut")
                    POTButtonView(image: "arrow.up", texte: "Haut")
                    POTButtonView(image: "arrow.up", texte: "Haut")
                }
            }
        }.ignoresSafeArea()
    }
}


struct ModaleEditPOT: View {
    
    @Binding var isPresented: Bool
    var image: String
    var texte: String
    
    var body: some View {
        ZStack {
            Color(Theme.unbleach)
            VStack {
                POTImageView(image: image, texte: texte)
                TextField("Nom du POT", text: .constant(""))
                    .padding()
                    .background(Theme.frame)
                    .cornerRadius(10)
                    .padding()
                
                TextField("Description du POT", text: .constant(""))
                    .padding()
                    .background(Theme.frame)
                    .cornerRadius(10)
                    .padding()
                Button(action: {
                    isPresented = false
                }) {
                    ButtonNext()
                }
            }
            
        }.ignoresSafeArea()
    }
}

struct POTButtonView: View {
    
    @State var isPresented: Bool = false
    var image: String
    var texte: String
    
    var body: some View {
        VStack {
            Button(action: {
                isPresented = true
            }) {
                POTImageView(image: image, texte: texte)
            }.sheet(isPresented: $isPresented) {
                ModaleEditPOT(isPresented: $isPresented, image: image, texte: texte)
            }
        }
    }
}

struct POTImageView: View {
    
    var image: String
    var texte: String
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Theme.frame)
                    .frame(width: 100, height: 100)
                    .shadow(radius: Consts.UI.shadowRadius)
                    .opacity(0.3)
                Image(systemName: image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.black)
            }
            .padding()
            
            Text(texte)
                .foregroundStyle(.black)
        }
    }
}



//#Preview {
//    POTAddView()
//}
//#Preview {
//    ModaleEditPOT()
//}
