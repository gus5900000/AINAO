//
//  POTEditView.swift
//  AINAO_Nav
//
//  Created by FrancoisW on 26/06/2024.
//

import SwiftUI
import MapKit

struct POTEditView: View {
    // TODO this will be changed with a @Binding
    @State var POTs: [POT] = []
    @State var POIs: [POI] = []

    @State var description: String = ""
    @State private var selectedTheme = "Dark"
    let themes = ["narrow_passage", "noisy_area", "steps", "windy_area"]
    @State private var isShowingForm = false // Etat pour contrôler l'affichage de la vue du formulaire

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Point of Trouble", selection: $selectedTheme) {
                        ForEach(themes, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    List {
                        ForEach(POTs) { item in
                            NavigationLink(destination: VStack(alignment: .leading) {
                                Text("Item at \(item.expirationDate, format: Date.FormatStyle(date: .numeric, time: .standard))")
                                Text("Pot type is: \(item.potType)")
                                Text("Description is: \(item.description)")
                            }) {
                                Text(item.expirationDate, format: Date.FormatStyle(date: .numeric, time: .standard))
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
                
            } // fin form
            .navigationTitle("POT")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { // Placement à gauche de la barre de navigation
                    Button(action: {
                        isShowingForm = true // Activer l'affichage du formulaire lors du clic sur le bouton
                    }) {
                        Label("Custom Button", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
        .sheet(isPresented: $isShowingForm) {
            POTFormView(POTs : $POTs)
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = POT(type: .icy_slippery_area, sourceRef: UUID(), sourceType: .ainaoNavUser, description: description, placemark: Placemark(latitude: Consts.Map.defaultCoordinate.latitude, longitude: Consts.Map.defaultCoordinate.longitude))
            POTs.append(newItem)
            print("POT Added: \(POTs.count)")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                POTs.remove(at: index)
            }
        }
    }
}

#Preview {
    POTEditView()
}
