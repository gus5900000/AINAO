//
//  SearchBarView.swift
//  AINAO_Nav
//
//  Created by FrancoisW on 28/06/2024.
//

import SwiftUI
import MapKit


struct SearchBarView: View {
    @FocusState  var searchFieldFocus: Bool
    @State private var searchText : String = ""
    @Binding  var searchResults: [MKMapItem]
    @Binding  var visibleRegion: MKCoordinateRegion?



    var body: some View {
        ZStack {
            let _ = print("C'est la search Bar")
            
            RoundedRectangle(cornerRadius: 12.0)
                .fill(Color .white)
            //                .stroke(Theme.fill, lineWidth: 2)
                .frame(width: 350 ,height: 30 )
            
            HStack {
                TextField("Rechercher ...", text: $searchText)
                //                .textFieldStyle(.roundedBorder)
                    .focused($searchFieldFocus)
                    .padding()
                //
                /*alignment: .trailing*/
                
                if searchFieldFocus {
                    let _ = print("Search Field Focus")
                    
                    Spacer()
                    Button {
                        searchText = ""
                        searchFieldFocus = false
                    }
                label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Theme.color30)
                        .padding(.trailing)
                }
                .frame(alignment: .trailing)
                }
            } .padding()
                .onSubmit {
                    Task {
                        await MapManager.searchPlaces(
                            searchResult : &searchResults,
                            searchText: searchText,
                            visibleRegion: visibleRegion
                        )
                        searchText = ""
                    }
                }
            if !searchResults.isEmpty {
                let _ = print("Search placement not empty ? \(searchResults.count)")
                let _ = print(searchResults[0].name)
                Button {
                    MapManager.removeSearchResults(searchResult: &searchResults)
                }label: {
                    Image(systemName: "mappin.slash.circle.fill")
                        .imageScale(.large)
                }
                .foregroundStyle(.white)
//                .padding(8)
                .background(.red)
                .clipShape(.circle)
            }
        }
    }
    }


struct SearchBarView_Previews: PreviewProvider {
    // Correctly initialize an empty array of MKMapItem
    static var mockSearchResults: [MKMapItem] = []

    static var mockRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), // Coordinates for Paris
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    static var previews: some View {
        SearchBarView(searchResults: .constant(mockSearchResults), visibleRegion: .constant(mockRegion))
    }
}
