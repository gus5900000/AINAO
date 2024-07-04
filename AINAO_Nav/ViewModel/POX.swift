//
//  POX.swift
//  EatSideStory
//
//  Created by FrancoisW on 20/06/2024.
//

import Foundation
import SwiftData
import MapKit
import SwiftUI

enum POXSource: Codable {
    case currentUser // POX has been created by the user himself
    case ainaoNavUser // POX has been created by another user of the AINAO Nav application
    case bleBeacon  // POX comes from a detected Bluetooth Low Energy beacon
    case other  // POX has been obtained from other external sources such as open data provided by cities, states
}

class POX: Placemark {
    var dbRef : String? // reference of the object in the remote database
    var sourceRef: UUID?
    var sourceType: POXSource
    var description: String?
    var image: String?
    
    init(dbRef : String? = nil, sourceRef: UUID? = nil, sourceType: POXSource? = nil, type: PlacemarkType, description: String? = nil, image: String? = nil, placemark: Placemark) {
        self.dbRef = dbRef
        self.sourceRef = sourceRef
        self.sourceType = sourceType ?? .other // Sourcetype isn't an optional property
        self.description = description
        self.image = image
        
        // Call the designated initializer of the superclass 'Placemark'
        super.init(id: placemark.id, name: placemark.name, address: placemark.address, latitude: placemark.latitude, longitude: placemark.longitude, type: type)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sourceRef = try container.decode(UUID.self, forKey: .sourceRef)
        sourceType = try container.decode(POXSource.self, forKey: .sourceType)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        
        try super.init(from: decoder)
    }
    
    // TODO: Implement the backing data initializer according to SwiftData's requirements
    required init(backingData: any SwiftData.BackingData<Placemark>) {
        fatalError("init(backingData:) has not been implemented")
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sourceRef, forKey: .sourceRef)
        try container.encode(sourceType, forKey: .sourceType)
        try container.encode(description, forKey: .description)
        try container.encode(image, forKey: .image)
        
        try super.encode(to: encoder)
    }
    
    private enum CodingKeys: String, CodingKey {
        case sourceRef
        case sourceType
        case description
        case image
    }
}
