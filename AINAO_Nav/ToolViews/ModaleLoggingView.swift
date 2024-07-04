//
//  ModaleLoggingView.swift
//  EatSideStory
//
//  Created by Apprenant 101 on 20/06/2024.
//

import SwiftUI

struct ModaleLoggingView: View {
    
    @Binding var isPresented: Bool
    var text: String
    
    var body: some View {
        ZStack {
            Image("BackgroundLoggin")
                .blur(radius: 10)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image(systemName: "heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    
                Text(text)
                    .foregroundStyle(Theme.color10)
                    .font(.system(size: 40))
                    .bold()
                    .frame(width: 400)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
        .ignoresSafeArea()
    }
}


//#Preview {
//    ModaleLoggingView()
//}
