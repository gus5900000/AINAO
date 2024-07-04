//
//  RoundedRectangleImage.swift
//  FruitList
//
//  Created by Apprenant 46 on 25/04/2024.
//

import SwiftUI

struct RoundedRectangleImage: View {
    var image: Image
    var size: Int
    var body: some View {
            image
              .resizable()
                  .aspectRatio(contentMode: .fill) // Maintain the aspect ratio
                .clipShape(RoundedRectangle(cornerRadius:Consts.UI.cornerRadiusFrame))
                .frame(maxWidth: CGFloat(size), maxHeight: CGFloat(size)) // Set the maximum width and height
        
        
        

    }
}

#Preview {
    RoundedRectangleImage(image : Image(systemName: "fireworks"),size : 200)
}

#Preview {
    RoundedRectangleImageFull(image : Image(systemName: "fireworks"), color : Theme.color60,size : 200)
}


struct RoundedRectangleImageFull: View {
    var image: Image
    var color: Color
    var size: Int
    var body: some View {
        
        let myImage = image.foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
        myImage
           .clipShape(RoundedRectangle(cornerRadius:Consts.UI.cornerRadiusFrame))
            .overlay(RoundedRectangle(cornerRadius: Consts.UI.cornerRadiusFrame).stroke(Color.white, lineWidth: 4))
            .background(RoundedRectangle(cornerRadius: Consts.UI.cornerRadiusFrame)
            .fill(color))
            .shadow(radius: Consts.UI.shadowRadius)


            // Coloured background
            image
                .resizable()
                .aspectRatio(contentMode: .fit
                )
                .clipShape(RoundedRectangle(cornerRadius:Consts.UI.cornerRadiusFrame))
                .overlay(RoundedRectangle(cornerRadius: Consts.UI.cornerRadiusFrame).stroke(Color.white, lineWidth: 4))
                .background(RoundedRectangle(cornerRadius: Consts.UI.cornerRadiusFrame).fill(color)
                //    .fill(Theme.fill)
                
                )

                .shadow(radius: Consts.UI.shadowRadius)
                .frame(width : CGFloat(size), height: CGFloat(size))
    }
    
  
}

