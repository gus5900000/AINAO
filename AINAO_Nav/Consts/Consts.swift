//
//  Consts.swift
//  EatSideStory
//
//  Created by FrancoisW on 07/06/2024.
//

import Foundation
import SwiftUI
import MapKit

struct Consts {
    struct UI {
        static let cornerRadiusFrame : CGFloat = 10
        static let cornerRadiusButton : CGFloat = 12
        static let shadowRadius : CGFloat = 10
        
        static let buttonInsideSize : Double = 25
        static let buttonOutsideSize : Double = 45
        
        
        static let splashscreenName : String = "Street"
 //     static let splashscreenName : String = "TrafficResto"
        static let appLogo : String = "Ainao3"
        //   static let appLogo : String = "GreenScreenLogoTransparent"
        static let doneButtonName = "Terminé"

        
        
    }
    struct CSV {
        static let EOL : String = "\n"
        static let separator : String = ";"
        // static let fileName : String = "rawdata"
        static let fileName : String = "restaurantv2-raw"
    }
    struct Storage {
        static let userProfileKey = "userProfile"
        static let userProfileImageKey = "userProfileImage"
    }
    struct Theme1 {
        static let unbleach : Color = Color(hex:0xBFAF7E) // BFAF7E
        static let color30 : Color = Color(hex:0x2995D9) //2995D9
        static let color10 : Color = Color(hex:0x401C14) //401C14
        static let color60 : Color = Color(hex:0xCDD9BA) //CDD9BA
        static let fill : Color = Color(hex:0xD9D9D9) //D9D9D9
        static let frame: Color = Color(hex:0xFFFFFE) //FFFFFE
        static let appleGrey : Color = Color(hex:0xF7F7F6) //F7F7F6
    }
    
    struct Theme2 {
        static let unbleach : Color = Color(hex:0xBFAF7E) // BFAF7E
        static let color30 : Color = Color(hex:0x2995D9) //2995D9
        static let color10 : Color = Color(hex:0x401C14) //401C14
        static let color60 : Color = Color(hex:0xEB2323) //EB2323
        static let fill : Color = Color(hex:0xD9D9D9) //D9D9D9
        static let frame: Color = Color(hex:0xFFFFFE) //FFFFFE
        static let appleGrey : Color = Color(hex:0xF7F7F6) //F7F7F6

    }
    struct Map{
        static let simplonCoordinate = CLLocationCoordinate2D(latitude: 50.6242076, longitude: 3.0596525)
        static let defaultCoordinate = simplonCoordinate
        //static let homeCoordinate = CLLocationCoordinate2D(latitude: 50.711615, longitude: 3.247395)
        
        static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003) // span is in degrees of Latitude and logitude
        static let defaultLatitudeMeters : Double = 1500
        static let defaultLongitudeMeters : Double = 1500
        static let defaultLatitudeDelta : Double = 0.0125
        static let defaultLongitudeDelta : Double = 0.0125
        static let visibleRegionRadius : Double = 3000 // radius is in meters, thus 3KM is our default radius
        
        
    }
    struct Icon {
        static let toiletFill = "toilet.fill"
        // static let figureFall = "toilet.fill"
    }
    struct POTPOI {
        static let defaultPOTValidity : Double = 24 * 60 * 60 // 1 day
    }
    struct Services {
        static let airtableMainDBKey : String = "patymal0zBhw9grIg.81d3af30686abfc615933424d7b798396dede534aacf0901653f6591d90af6af"
        static let airtableMainDBImportRequest : String = "https://api.airtable.com/v0/appZKhtxsDMtvCnzo/UserData%20Log"
        static let airtableCriteriaDBImportRequest : String = "https://api.airtable.com/v0/appZKhtxsDMtvCnzo/Criteria"
        static let airtablePOIDBImportRequest : String = "https://api.airtable.com/v0/appZKhtxsDMtvCnzo/POI"
        static let airtablePOTDBImportRequest : String = "https://api.airtable.com/v0/appZKhtxsDMtvCnzo/POT"
    }
    
}
