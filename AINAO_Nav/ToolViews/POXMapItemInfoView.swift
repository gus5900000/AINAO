//
//  POXMapItemInfoView.swift
//  AINAO Nav
//
//  Created by FrancoisW on 26/06/2024.
//

import Foundation
import SwiftUI
import MapKit

struct POXMapItemInfoView: View {
    @State private var lookAroundScene: MKLookAroundScene?
    
    @State private var name = ""
    @State private var description = ""
    @State var selectedPotType: POTType = .narrow_passage // Default selection
    

    var selectedResult : MKMapItem
    var route: MKRoute?
    @Binding var userCreatedMapItem: UnifiedMapItem?
    @Binding var doDisplayPOXMapItemInfoView : Bool
    @Binding var userProfile : UserProfile
    
    // Formatter to display travel time in a readable format
    private var travelTime: String? {
        guard let route else { return nil }
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: route.expectedTravelTime)
    }
    
    // Function to fetch Look Around scene for the selected map item
    func getLookAroundScene() async {
        lookAroundScene = nil
        do {
            let request = MKLookAroundSceneRequest(mapItem: selectedResult)
            lookAroundScene = try await request.scene
        } catch {
            print("Error fetching Look Around scene: \(error)")
        }
    }
    
    var isChanged: Bool {
        return (name != selectedResult.name || description != selectedResult.description)
    }
    
    var body: some View {
        var isPOT : Bool = true
        var potType : POTType = .crowded_area
        var poiType : POIType = .bench

        ZStack {
            Color(Theme.color60) // Background color for the entire view
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Spacer()
                        
                        Text("Signalez un problème")
                            .font(.title2)
                        
                        TextField("Nom", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled()
                        
                        ZStack(alignment: .topLeading) {
                             TextField("", text: $description)
                                .frame(height: 120) // Set a default height for the TextField
                                .padding(.horizontal, 4)
                                .padding(.vertical, 8)
                                .background(Color.white) // Set background color to white
                                .cornerRadius(8) // Add corner radius to match the border
                                .foregroundColor(Theme.color10) // Set text color
                                .font(.body) // Match the TextField's font
                            if description.isEmpty {
                                Text("Description")
                                     .foregroundColor(.gray) // Placeholder text color
                                     .padding(.horizontal, 8)
                                     .padding(.vertical, 12)
                                     .font(.body) // Ensure the placeholder font matches the TextField font
                            }
                            /*
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1) // Add a border with rounded corners
                                )
                             */
                        }
                        .padding([.top, .bottom])
                        
                        HStack {
                            Text("Type de problème")
                                .font(.title2) // Set the font size to match the title
                                .foregroundColor(Theme.color10) // Set the color to match the title

                            Picker(selection: $selectedPotType, label: Text("Type").font(.title2).foregroundColor(.red)) {
                                ForEach(POTType.allCases, id: \.self) { potType in
                                    Text(potType.displayName).tag(potType)
                                }
                            }
                            //.pickerStyle(MenuPickerStyle())
                        }
                        .foregroundColor(Theme.color10)
                        .font(.title2)
                        
                        HStack {
                            Button("Signaler") {
                                Task {
                                    userCreatedMapItem = UnifiedMapItem(mapItem: selectedResult)  // This is created to get the position, then user will need to define what he wants to do with it
                                    
                                    userCreatedMapItem!.name = name
                                        .trimmingCharacters(in: .whitespacesAndNewlines)
                          //          userCreatedMapItem!.description = description
                            //            .trimmingCharacters(in: .whitespacesAndNewlines)
                                    
                                    userCreatedMapItem!.description = "Bonjour"
                                    //            .trimmingCharacters(in: .whitespacesAndNewlines)
                                    
                                    let placemark = Placemark(placemark: userCreatedMapItem!.placemark, newName: name)
                                    
                                    if isPOT {
                                        let pot = POT(type: potType, sourceRef: userProfile.id, sourceType: .currentUser, placemark: placemark)
                                        await userProfile.addPOT(with: pot)
                                    } else {
                                        let poi = POI(type: poiType, sourceRef: userProfile.id, sourceType: .currentUser, placemark: placemark)
                                        await userProfile.addPOI(with: poi)
                                    }
                                }
                                doDisplayPOXMapItemInfoView = false

                            }
                            .buttonStyle(.borderedProminent)
                            .foregroundColor(Theme.color10)
                            .tint(Theme.color30)
                            .frame(width: 150, height: 40)
                            .background(Theme.color30) // Ensure the background fills the frame
                            .cornerRadius(8) // Optional: Add corner radius for better visuals
                            .multilineTextAlignment(.center)
                            .padding()

                            Button("Annuler") {
                                doDisplayPOXMapItemInfoView = false
                            }
                            .buttonStyle(.borderedProminent)
                            .foregroundColor(Theme.color10)
                            .tint(Theme.color30)
                            .frame(width: 150, height: 40)
                            .background(Theme.color30) // Ensure the background fills the frame
                            .cornerRadius(8) // Optional: Add corner radius for better visuals
                            .multilineTextAlignment(.center)
                            .padding()
                        }
                        .background(Color.clear) // Optional background color for contrast
                    }
                }

                
                
                if let lookAroundScene {
                    LookAroundPreview(initialScene: lookAroundScene)
                        .overlay(alignment: .bottomTrailing) {
                            HStack {
                                Text("\(selectedResult.name ?? "")")
                                if let travelTime {
                                    Text(travelTime)
                                        .foregroundStyle(.red)
                                }
                            }
                            .font(.caption)
                            .foregroundStyle(Theme.frame)
                            .padding(10)
                        }
                } else {
                    // Display Nothing
                    /*
                     ContentUnavailableView("No preview available", systemImage: "eye.slash")
                     .foregroundStyle(Theme.color10)
                     */
                }
            }
            .padding()
            .task {
                await getLookAroundScene()
            }
            .onChange(of: selectedResult) { _ in
                Task {
                    await getLookAroundScene()
                }
            }
        }
    }
}

struct POXMapItemInfoView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a mock MKMapItem and other necessary data to preview the view
        ZStack {
            Color(Theme.color60)
                .ignoresSafeArea()
            POXMapItemInfoView(selectedResult: MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 43.6045, longitude: 1.4440))), route: nil, userCreatedMapItem: .constant(nil), doDisplayPOXMapItemInfoView: .constant(true), userProfile: .constant(UserProfile()))
        }
    }
}
