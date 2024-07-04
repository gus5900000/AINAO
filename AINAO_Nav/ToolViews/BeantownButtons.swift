//
//  BeantownButtons.swift
//  SwingsAndSand
//
//  Created by FrancoisW on 25/06/2024.
//

import SwiftUI
import MapKit

struct BeantownButtons: View {
    @Binding  var searchResults: [MKMapItem]
    @Binding  var position: MapCameraPosition
    var visibleRegion : MKCoordinateRegion?


    var body: some View {
        HStack{
            Button {
                search(for:"Bars",visibleRegion: visibleRegion)
            } label : {
                Label("Playgrounds",systemImage : "figure.and.child.holdinghands")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                search(for:"Plages",visibleRegion: visibleRegion)
            } label : {
                Label("Beaches",systemImage : "beach.umbrella")
            }
            .buttonStyle(.borderedProminent)
            
            /*
            Button {
                position = .region(.simplon)
            } label : {
                Label("Simplon,",systemImage : "building.2")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
             //   position = .region(.home)

            } label : {
                Label("Estaimpuis",systemImage : "house.lodge")
            }
            .buttonStyle(.borderedProminent)
*/
        }
        .labelStyle(.iconOnly)
    }
    
    // Search func takes a String parameter named query
    func search(for query : String,visibleRegion: MKCoordinateRegion?) {
        
  
        Task {
            await MapManager.searchPlaces(
                searchResult : &searchResults,
                searchText: query,
                visibleRegion: visibleRegion
            )
        }

    }

}

/*
 #Preview {
 BeantownButtons(searchResults: .constant([MKMapItem]))
 }
 */
