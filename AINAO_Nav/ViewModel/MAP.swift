//
//  MAP.swift
//  EatSideStory
//
//  Created by FrancoisW on 20/06/2024.
//

import Foundation
import MapKit

/*
    Unified map item model that can handle, Placemarks,MKMapItem and annotations (using CLLocationCoordinate2D)
*/
class UnifiedMapItem: Identifiable {
    let id: UUID
    private(set) var potType: POTType? // Read-only from outside the class
    private(set) var poiType: POIType?
    private(set) var expirationDate: Date?
    var name: String?
    var description: String?

    var image: String?
    var mapItem: MKMapItem
    private(set) var placemark: Placemark
    var pox : POX?

    // mapitem Coordinates take precedence over placemark.coordinate
    var coordinate: CLLocationCoordinate2D {
        mapItem.placemark.coordinate
    }
    
    init(mapItem: MKMapItem, name: String? = nil ,description: String? = nil, image: String? = nil) {
        self.id = UUID()
        self.name = name
        self.description = description
        self.image = image
        self.mapItem = mapItem
        
        self.placemark = Placemark(
            id: nil, // A new UUID will be generated
            name: mapItem.name,
            address: mapItem.placemark.title,
            latitude: mapItem.placemark.coordinate.latitude,
            longitude: mapItem.placemark.coordinate.longitude,
            type: .temporary // or another appropriate default value
        )
    }
    
    // Public methods to change the values of private(set) properties
    func setPotType(_ newPotType: POTType) {
        if poiType != nil {
            fatalError("Cannot mutate a POI into a POT")
        }
        self.potType = newPotType
    }
    
    func setPoiType(_ newPoiType: POIType) {
        if potType != nil {
            fatalError("Cannot mutate a POT into a POI")
        }
        self.poiType = newPoiType
    }
    
    func setExpirationDate(_ newExpirationDate: Date) {
        if potType == nil {
            fatalError("Cannot assign an expiration date to anything else than a POT")
        }
        self.expirationDate = newExpirationDate
    }
    
    func setPlacemark(_ newPlacemark: Placemark) {
        self.placemark = newPlacemark
    }
    
    // Add methods to set description and image if needed...
}
