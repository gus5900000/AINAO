//  PlacemarkViewModel.swift
//  AINAO Nav
//
//  Created by FrancoisW on 22/06/2024.
//
import Foundation
import SwiftUI
import SwiftData
import MapKit


enum PlacemarkError: Error {
    case placemarkNotFound(UUID)
    case placemarkAlreadyExists(UUID)
}

@Model
final class PlacemarkViewModel  {
    private var placemarks: Set<Placemark>
    var arePlacemarksLoaded: Bool
    var lastUpdate: Date

    public var allPlacemarks: [Placemark] {
       return Array(placemarks)
    }
    
    init(placemarks: Set<Placemark>? = nil) {
        self.placemarks = placemarks ?? Set<Placemark>()
        self.arePlacemarksLoaded = false
        self.lastUpdate = Date()
    }
    
    // Public method to add a placemark
    public func addPlacemark(_ placemark: Placemark) throws {
        guard !placemarks.contains(placemark) else {
            throw PlacemarkError.placemarkAlreadyExists(placemark.id)
        }
        placemarks.insert(placemark)
        self.lastUpdate = Date() // Update the last update date
    }
    
    // Public method to remove a placemark
    public func removePlacemark(_ placemark: Placemark) throws {
        guard placemarks.contains(placemark) else {
            throw PlacemarkError.placemarkNotFound(placemark.id)
        }
        placemarks.remove(placemark)
        self.lastUpdate = Date() // Update the last update date
    }
    
    // Public method to remove all placemarks of a given type
    public func removePlacemarksOfType(ofType type: PlacemarkType) {
        placemarks = placemarks.filter { $0.type != type }
        self.lastUpdate = Date() // Update the last update date
    }
    // Method to filter placemarks by a set of types
        public func filterPlacemarks(keepingTypes types: Set<PlacemarkType>) {
            placemarks = placemarks.filter { types.contains($0.type) }
            self.lastUpdate = Date() // Update the last update date
        }

    // Public method to add an array of placemarks to the set
    public func addPlacemarks(_ newPlacemarks: [Placemark]) throws {
        var tempPlacemarks = placemarks // We use tempPlacemarks to make sure that if there is an error, the placemar-ks set stays untouched
        
        for placemark in newPlacemarks {
            if tempPlacemarks.contains(placemark) {
                throw PlacemarkError.placemarkAlreadyExists(placemark.id)
            } else {
                tempPlacemarks.insert(placemark)
            }
        }
        placemarks = tempPlacemarks // If no error is thrown, update the main set
        self.lastUpdate = Date() // Update the last update date
    }
}

// Public method to merge two placemarks set, CAUTION : duplicates will be deleted

extension PlacemarkViewModel {
    static func + (lhs: PlacemarkViewModel, rhs: PlacemarkViewModel) -> PlacemarkViewModel {
        let mergedPlacemarks = lhs.placemarks.union(rhs.placemarks)
        let mergedViewModel = PlacemarkViewModel(placemarks: mergedPlacemarks)
        mergedViewModel.lastUpdate = Date() // Set to current date
        return mergedViewModel
    }
}

extension PlacemarkViewModel {
    func placemarksAround(within distance: CLLocationDistance, of coordinate: CLLocationCoordinate2D) -> [Placemark] {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return placemarks.filter { placemark in
            let placemarkLocation = CLLocation(latitude: placemark.latitude, longitude: placemark.longitude)
            return placemarkLocation.distance(from: location) <= distance
        }
    }
}
