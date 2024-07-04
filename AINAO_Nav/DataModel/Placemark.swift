//
//  Placemark.swift
//  EatSideStory
//
//  Created by FrancoisW on 16/06/2024.
//

import Foundation
import SwiftData
import MapKit

enum PlacemarkType: String, Codable, Hashable {
    case poi // Placemark is a POI
    case pot // Placemark is a POT
    case origin // Placemark to display the origin of a route
    case destination // Placemark to display the destination of a route
    case searched // Placemark to identify locations resulting of a search
    case userLocation // Placemark that identifies the user location
    case temporary // Temporaryplacemark, use doesn't lknow yet what to do with it
    case unassigned // this is the default value when a Placemark is created without information about its type
}

class Placemark: Codable, Hashable, Equatable {
    static func == (lhs: Placemark, rhs: Placemark) -> Bool {
        return lhs.id == rhs.id
    }

    
    var id: UUID
    var type: PlacemarkType
    var name: String? // Only descriptive, no link with location
    var address: String?
    
    // For the momment these parameters are public
    var latitude: Double
    var longitude: Double

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case name
        case address
        case latitude
        case longitude
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        type = try container.decode(PlacemarkType.self, forKey: .type)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        address = try container.decodeIfPresent(String.self, forKey: .address)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        print("Placemark initialized from decoder: \(self)")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encode(address, forKey: .address)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        print("Placemark encoded: \(self)")
    }
    
    init(id: UUID? = nil, name: String? = nil, address: String? = nil, latitude: Double? = nil, longitude: Double? = nil, type: PlacemarkType? = nil) {
        var areCoordinatesValid = true
        
        self.id = id ?? UUID() // Provide a default UUID if `id` is nil. UUID is not an option!
        self.name = name
        self.address = address
        
        // Francois is a nice guy (but Copilot helped him
        // Check if the latitude and longitude are within valid ranges.
         // If not, or if they are nil, use the default values.
        // Set default coordinates
        let defaultLatitude = Consts.Map.simplonCoordinate.latitude
        let defaultLongitude = Consts.Map.simplonCoordinate.longitude

        // Validate coordinates
        let isLatitudeValid = latitude != nil && (-90...90).contains(latitude!)
        let isLongitudeValid = longitude != nil && (-180...180).contains(longitude!)

        if isLatitudeValid && isLongitudeValid {
            self.latitude = latitude!
            self.longitude = longitude!
        } else {
            // If either coordinate is invalid or nil, use default values for both
            self.latitude = defaultLatitude
            self.longitude = defaultLongitude
        }

        self.type = type ?? .unassigned // Provide a default type if `type` is nil
    }
    
    // Convenience initializer to create a new Placemark from an existing one. CAUTION: the id of the Original placemark is KEPT.
    convenience init(placemark: Placemark, newType: PlacemarkType? = nil, newName: String? = nil, newAddress: String? = nil) {
        self.init(
            id: placemark.id, // Keep the same ID
            name: newName ?? placemark.name,
            address: newAddress ?? placemark.address,
            latitude: placemark.latitude,
            longitude: placemark.longitude,
            type: newType ?? placemark.type
       )
        print("Placemark convenience initializer called: \(self)")
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// To compute the distance between a CLLocationCoordinate2D and a Placemark
extension Placemark {
    func distance(to coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let start = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let end = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let distance = start.distance(from: end)
        print("Distance calculated from \(self.coordinate) to \(coordinate): \(distance) meters")
        return distance
    }
}

extension Placemark {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
