//
//  CircleImageView.swift
//  AINAO_Nav
//
//  Created by FrancoisW on 28/06/2024.
//

import SwiftUI

struct CircleImageView: View {
    var image : Image
    var size : Double = 250
    
    var body: some View {

        image
            .resizable()
            .aspectRatio(contentMode: .fit)
           .clipShape(.circle)
            .padding()
            .frame(width: size, height: size) // Specify your desired dimensions here
    }
}

#Preview {
    CircleImageView(image : Image("clint"),size : 85)
}
