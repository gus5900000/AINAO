//
//  POI.swift
//  EatSideStory
//
//  Created by FrancoisW on 20/06/2024.
//

import Foundation
import SwiftUI
import SwiftData

// Ensure enums conform to Codable if they are used in a Codable class
enum POIType: Codable, CaseIterable {
    case toilets
    case bench
    case coolDown
    case drinking_water
    case defibrillator
    case inclusive_culture
    case first_aid
    case interfaith_chapel

    var displayName: String {
        switch self {
        case .toilets:
            return "Toilettes"
        case .bench:
            return "Banc"
        case .coolDown:
            return "Fraicheur"
        case .drinking_water:
            return "Eau"
        case .defibrillator:
            return "Défibrilateur"
        case .inclusive_culture:
            return "Culture Inclusive"
        case .first_aid:
            return "Secours"
        case .interfaith_chapel:
            return "Interconfession"
        }
    }

    /***
        HERE DO PLACE THE ICON NAME (icons from the system or icons in the assets)
        where to g-fin icons : https://www.iconfinder.com/search?q=museum&price=free
     https://www.svgrepo.com/vectors/steep/
     
     
         Tou need to choose SVG files !!!! ant then insert them in the assets, and then:
         Open your asset catalog in Xcode.
         
         Select your custom image.
         In the attributes inspector on the right, look for the “Render As” option.
         Choose “Template Image” from the dropdown menu.
         This will tell SwiftUI to treat the image as a template image, which will allow the image’s color to be changed with .foregroundColor().
         
     */
    var iconName: String {
        switch self {
        case .toilets:
            return "toilet"
        case .bench:
            return "bench" // Suggested alternative icon name for a bench
        case .coolDown:
            return "snowflake.circle.fill"
        case .drinking_water:
            return "drop.circle.fill" // Example icon name for drinking water
        case .defibrillator:
            return "bolt.heart.fill"
        case .inclusive_culture:
            return "inclusive" // Example icon name for inclusive culture
        case .first_aid:
            
            return "cross.case.fill"
        case .interfaith_chapel:
            // return "interfaith_chapel" // Example icon name for interfaith chapel
            return "building.columns.circle.fill" // Example icon name for interfaith chapel
        }
    }
    
    /***
        Here tells the system where to search the icon
     */
    var isSystemIcon: Bool {
          switch self {
              // Here place non system Icons
          case .bench,.inclusive_culture:
              return false
          default:
              return true
          }
      }

    
    var iconImage: Image {
         return isSystemIcon ? Image(systemName: iconName) : Image(iconName)
     }

}

struct CriterionPOI {
    let type : POIType
    var isSet : Bool
}

class POI: POX, Identifiable {
    var poiType: POIType

    init(type: POIType, sourceRef: UUID, sourceType: POXSource,  description: String? = nil, image : String? = nil, placemark: Placemark) {
        self.poiType = type
        super.init(sourceRef: sourceRef, sourceType: sourceType, type: .poi, description: description, image : image, placemark: placemark)
    }
    
    // Implement the Encodable protocol
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(poiType, forKey: .poiType)
        
        // Call the superclass's implementation of encode(to:)
        try super.encode(to: encoder)
    }
    
    // Implement the Decodable protocol
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        poiType = try container.decode(POIType.self, forKey: .poiType)
        
        // Call the superclass's implementation of init(from:)
        try super.init(from: decoder)
    }
    
    required init(backingData: any SwiftData.BackingData<Placemark>) {
        fatalError("init(backingData:) has not been implemented")
    }
    
    // Define the keys used for encoding and decoding
    private enum CodingKeys: String, CodingKey {
        case poiType
        case authorRef
        case authorSource
    }
    
 
}

