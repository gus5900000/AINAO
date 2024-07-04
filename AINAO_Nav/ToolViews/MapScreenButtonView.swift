//
//  MapScreenButtonView.swift
//  AINAO_Nav
//
//  Created by FrancoisW on 30/06/2024.
//

import SwiftUI

struct MapScreenButtonView: View {
    @State var systemName : String
    
    var body: some View {
        ZStack {
             Color.white.opacity(0.9)

         //   Color.white.opacity(0.7).blur(radius: 10)
              Image(systemName: systemName)

         //   Image(systemName:"magnifyingglass")
                .resizable()
                .frame(width: Consts.UI.buttonInsideSize, height: Consts.UI.buttonInsideSize)
                .foregroundColor(.Tcolor30)
        }
        .frame(width: Consts.UI.buttonOutsideSize, height: Consts.UI.buttonOutsideSize)

        .clipShape(Circle())
        //.buttonBorderShape(.circle)
    }
}

struct MapScreenButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Theme.color60
                .ignoresSafeArea()

            MapScreenButtonView(systemName: "magnifyingglass")
                .previewLayout(.sizeThatFits)
        }
    }
}
