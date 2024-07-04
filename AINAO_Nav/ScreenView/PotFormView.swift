//
//  POTFormView.swift
//  AINAO_Nav
//
//  Created by  Ixart on 27/06/2024.
//

import SwiftUI

struct POTFormView: View {
    
    // Add a presentation mode variable to dismiss the view
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var POTs : [POT]
    
    @State private var selectedPotType: POTType = .narrow_passage
    @State private var potType: String = ""
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var latitude: Double = 0
    @State private var longitude: Double = 0
    
    // Use the rawValue of the POTType cases for the Picker
    // Convert the POTType cases to an array of strings
    let potTypes = POTType.allCases.map { "\($0)" }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    HStack {
                        Text("Type")
                            .foregroundColor(Theme.color10)
                        Spacer()
                        Picker("", selection: $selectedPotType) {
                            ForEach(POTType.allCases, id: \.self) { potType in
                                Text(potType.displayName).tag(potType)
                            } // fin for each
                        }
                        .pickerStyle(MenuPickerStyle()) // style
                        .frame(width: 180) // largeur du Picker
                    }
                    TextField("Name", text: $name)
                        .foregroundColor(Theme.color10)

                    TextField("Description", text: $description)
                        .foregroundColor(Theme.color10)
                        .frame(width: 100, height: 100)


                } // fin section 1
                
                
                Section(header: Text("Location")) {
                    HStack {
                        Text("Latitude")
                        Spacer()
                        TextField("Latitude", value: $latitude, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                    } // fin hstack
                    
                    HStack {
                        Text("Longitude")
                        Spacer()
                        TextField("Longitude", value: $longitude, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                    } // fin hstack
                    
                    
                    
                } // fin de la section 2
                
            } // fin formulaire
            .navigationTitle("New POT Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack { // Wrap Button in VStack
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        Button("Save") {
                            let newPOT = POT(type: selectedPotType, sourceRef: UUID(), sourceType: .currentUser, description: description, placemark: Placemark(latitude: latitude, longitude: longitude))
                            POTs.append(newPOT)
                            presentationMode.wrappedValue.dismiss()
                        }
                        .disabled(name.isEmpty || latitude.isZero || longitude.isZero)
                        
                    }
                    
                }
                
                
            }
        } // Fin navigationview
        
        
        
    } // fin body
} // fin struct



#Preview {
    POTFormView(POTs: .constant([])) // Provide a binding to an empty array for preview purposes
}
