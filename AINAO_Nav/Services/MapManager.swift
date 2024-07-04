//
//  Extensions.swift
//  EatSideStory
//
//  Created by FrancoisW on 25/06/2024.
//


import MapKit
import SwiftData

enum MapManager {
    @MainActor
    static func searchPlaces(searchResult : inout [MKMapItem], searchText: String, visibleRegion: MKCoordinateRegion?) async {
        removeSearchResults(searchResult : &searchResult)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.resultTypes = [.address, .pointOfInterest] // we vould have specifify address, not sure what it would return, let's keep this value...

        if let visibleRegion {
            let _ = print("Search With Visible Region : \(visibleRegion.center.latitude)")

            request.region = visibleRegion
        }
        else {
            let _ = print("Search With No Visible Region !!!")
        }
        let searchItems = try? await MKLocalSearch(request: request).start()
        let results = searchItems?.mapItems ?? []
        
        // The response is put into SearchResults, if no response the response is an empty array
        searchResult = results
                
     }
    
    static func removeSearchResults(searchResult : inout [MKMapItem]) {
        searchResult.removeAll()
    }
}



