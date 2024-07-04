//
//  addpicker.swift
//  AINAO_Nav
//
//  Created by  Ixart on 26/06/2024.
//

import SwiftUI
import PhotosUI

@available(iOS 16.0, *)
struct AddpickerView: View {
    
    @State private var name = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil


    
    


 
    
    
    
    

    
    
    
    
    
    var body: some View {
        VStack{
            
            Form{
                Section {
                    TextField("choisi ta photo", text: $name)
                        .keyboardType(.alphabet)
                    
                    if let selectedImageData,
                          let uiImage = UIImage(data: selectedImageData) {
                           Image(uiImage: uiImage)
                               .resizable()
                               .scaledToFit()
                               .frame(width: 150, height: 150)
                       }

                       PhotosPicker(
                           selection: $selectedItem,
                           matching: .images,
                           photoLibrary: .shared()) {
                               Text("Choisir une image")
                           }
                          
                    
                    
                    
                    
                
                    
                } header: {
                    Text("ANIMAL IDENTITY")
                    
                } // fin du header
                
                Section {
                    Button("AJOUTEZ"){
                        
                        
                    }
                } // fin section
                .padding(.leading,120)

            } // fin form

            
            
            
            
                
            
        

            
            
            
            
            
        } // fin vstack
        

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    } // fin body

} // fin struct
@available(iOS 16.0, *)#Preview {
    AddpickerView()
}
