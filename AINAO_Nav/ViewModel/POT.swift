//
//  POT.swift
//  EatSideStory
//
//  Created by FrancoisW on 20/06/2024.
//

import Foundation
import SwiftData
import SwiftUI

// Ensure enums conform to Codable if they are used in a Codable class
enum POTType: Codable, CaseIterable {
    case narrow_passage
    case noisy_area
    case steps
    case windy_area
    case steep_slope
    case stairs
    case uneven_pavement
    case faulty_auditory_signals
    case crowded_area
    case faulty_escalator
    case faulty_elevator
    case icy_slippery_area
    case warm_area
    case insufficient_tactile_indicators

    
    var displayName: String {
        switch self {
        case .narrow_passage:
            return "Passage étroit"
        case .noisy_area:
            return "Bruyant"
        case .steps:
            return "Marche"
        case .windy_area:
            return "Vent"
        case .steep_slope:
            return "Pente"
        case .stairs:
            return "Escaliers"
        case .uneven_pavement:
            return "Sol inégal"
        case .faulty_auditory_signals:
            return "Signal défectueux"
        case .crowded_area:
            return "Foule"
        case .faulty_escalator:
            return "En panne"
        case .faulty_elevator:
            return "En panne"
        case .icy_slippery_area:
            return "Verglas"
        case .warm_area:
            return "Chaleur"
        case .insufficient_tactile_indicators:
            return "Manque tactile"
        }
    }
    
    var enumName : String {
        switch self {
        case .narrow_passage:
            return("narrow_passage")
        case .noisy_area:
            return "noisy_area"
        case .steps:
            return "steps"
        case .windy_area:
            return "wind"
        case .steep_slope:
            return "steep_slope"
        case .stairs:
            return "stairs"
        case .uneven_pavement:
            return "uneven_pavement"
        case .faulty_auditory_signals:
            return "auditory"
        case .crowded_area:
            return "person.3.fill"
        case .faulty_escalator:
            return "escalator"
        case .faulty_elevator:
            return "elevator"
        case .icy_slippery_area:
            return "snowflake"
        case .warm_area:
            return "thermometer.sun.fill"
        case .insufficient_tactile_indicators:
            return "tactile_indicator"
        }

        }
    
    var iconName: String {
        switch self {
        case .narrow_passage:
            return "arrow.left.and.right.righttriangle.left.righttriangle.right.fill"
        case .noisy_area:
            return "speaker.wave.3.fill"
        case .steps:
            return "steps"
        case .windy_area:
            return "wind"
        case .steep_slope:
            return "steep_slope"
        case .stairs:
            return "stairs"
        case .uneven_pavement:
            return "uneven_pavement"
        case .faulty_auditory_signals:
            return "auditory"
        case .crowded_area:
            return "person.3.fill"
        case .faulty_escalator:
            return "escalator"
        case .faulty_elevator:
            return "elevator"
        case .icy_slippery_area:
            return "snowflake"
        case .warm_area:
            return "thermometer.sun.fill"
        case .insufficient_tactile_indicators:
            return "tactile_indicator"
        }
    }
    
    /***
        Here tells the system where to search the icon
     */
    var isSystemIcon: Bool {
          switch self {
              // Here place non system Icons
          case .faulty_escalator,.faulty_elevator,.steep_slope ,.steps,.faulty_auditory_signals,.uneven_pavement,.insufficient_tactile_indicators:
              return false
          default:
              return true
          }
      }

    
    var iconImage: Image {
         return isSystemIcon ? Image(systemName: iconName) : Image(iconName)
     }

}



/***
 
 Example of usage of the class :
 
 //  Creating a POT with a specific validity duration of 2 days
 let twoDaysInSeconds = 2 * 24 * 60 * 60 // Convert 2 days to seconds
 let potWithTwoDayValidity = POT(
 author: UUID(),
 source: .user,
 type: .coolDown,
 validityDuration: twoDaysInSeconds,
 placemark: Placemark(name: "Cooling Spot", address: "789 Cool St", latitude: 34.0522, longitude: -118.2437)
 )
 
 */
class POT: POX,Identifiable {
    var potType: POTType
    var expirationDate: Date
    
    
    init(type: POTType, expirationDate: Date? = nil, sourceRef: UUID, sourceType: POXSource,  description: String? = nil, image : String? = nil, placemark: Placemark) {
        self.potType = type
        self.expirationDate = expirationDate ?? Date() + Consts.POTPOI.defaultPOTValidity
        
        super.init(sourceRef: sourceRef, sourceType: sourceType, type: .poi, description: description, image : image, placemark: placemark)
    }
    
    
    // Implement the Encodable protocol
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(potType, forKey: .potType)
        try container.encode(expirationDate, forKey: .expirationDate)
        
        // Call the superclass's implementation of encode(to:)
        try super.encode(to: encoder)
    }
    
    // Implement the Decodable protocol
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        potType = try container.decode(POTType.self, forKey: .potType)
        expirationDate = try container.decode(Date.self, forKey: .expirationDate)
        
        // Call the superclass's implementation of init(from:)
        try super.init(from: decoder)
    }
    
    required init(backingData: any SwiftData.BackingData<Placemark>) {
        fatalError("init(backingData:) has not been implemented")
    }
    
    // Define the keys used for encoding and decoding
    private enum CodingKeys: String, CodingKey {
        case potType
        case authorRef
        case authorSource
        case expirationDate
    }
}
