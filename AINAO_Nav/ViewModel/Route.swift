//
//  Route.swift
//  EatSideStory
//
//  Created by FrancoisW on 20/06/2024.
//

import Foundation
import MapKit

class Route {
    var id = UUID()
    var dbRef : String?
    var name : String?
    var description : String?
    var destination : CLLocationCoordinate2D
 
    init(dbRef: String? = nil, name: String? = nil, description: String? = nil, destination: CLLocationCoordinate2D) {
        self.name = name
        self.dbRef = dbRef
        self.description = description
        self.destination = destination
    }
 }
