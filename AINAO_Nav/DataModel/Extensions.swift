//
//  Extensions.swift
//  EatSideStory
//
//  Created by FrancoisW on 07/06/2024.
//

import Foundation
import SwiftUI
import MapKit

/**
 This extensions allows the creation of the color using its Hex representation and convert it into iOS Color RGB
 */
extension Color {
    init(hex: Int) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}


extension Color {
    static var Tunbleach: Color = Theme.unbleach
    static var Tcolor30: Color = Theme.color30
    static var Tcolor10: Color = Theme.color10
    static var Tcolor60: Color = Theme.color60
    static var Tfill: Color = Theme.fill
    static var Tframe: Color = Theme.frame
}

extension MKCoordinateRegion {
    static let boston = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 42.360256,
            longitude: -71.057279),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    
    static let simplon = MKCoordinateRegion(
        center: Consts.Map.simplonCoordinate,
        latitudinalMeters: Consts.Map.defaultLatitudeMeters,
        longitudinalMeters: Consts.Map.defaultLongitudeMeters
    )
    
    /*
    
    static let home = MKCoordinateRegion(
        center: Consts.Map.homeCoordinate,
        latitudinalMeters: Consts.Map.defaultLatitudeMeters,
        longitudinalMeters: Consts.Map.defaultLongitudeMeters
    )
    */
    static let toulouse = MKCoordinateRegion(
        center: .toulouseHQ,
        latitudinalMeters: Consts.Map.defaultLatitudeMeters,
        longitudinalMeters: Consts.Map.defaultLongitudeMeters
    )
}

extension CLLocationCoordinate2D {
    static let theatreSebastopol = CLLocationCoordinate2D(latitude: 50.62939218513652, longitude: 3.058239728757164)
    static let gareLilleFlandres = CLLocationCoordinate2D(latitude: 50.636833996237286, longitude: 3.0699861455295046)
    static let appleLille = CLLocationCoordinate2D(latitude: 50.63738517105418, longitude: 3.0657185557408337)
    static let belgiumHouse = CLLocationCoordinate2D(latitude: 50.71154841530979, longitude: 3.2473586395166003)
    static let simplon = CLLocationCoordinate2D(latitude: 50.6242076, longitude: 3.0596525)
    static let bdLiberte = CLLocationCoordinate2D(latitude: 50.63113131472848, longitude: 3.0628721517963995)
    static let toulouseHQ = CLLocationCoordinate2D(latitude: 43.6234469, longitude: 1.4433887)
}

/***
 
 Howw to Configure the simulator to simulate a foo user location ?
 Run your project in the iPhone Simulator.
 In the iOS Simulator menu, go to Features -> Location -> Custom Location.
 There, you can set the latitude and longitude to the desired values and test your app accordingly1.

 
 */
