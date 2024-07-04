
//  AppData.swift
//  EatSideStory
//
//  Created by FrancoisW on 07/06/2024.
//

import Foundation
import SwiftData

@Model 
final class AppData : ObservableObject{

    var timestamp: Date
    
    init(timestamp : Date = .now) {
        self.timestamp = timestamp
    }
}
