//
//  userModel.swift
//  AINAO_Nav
//
//  Created by Apprenant 101 on 25/06/2024.
//

import Foundation

// Modèle pour la réponse contenant les enregistrements de profils utilisateurs
struct UserProfilResponse: Decodable {
    let id: String
    let createdTime: String
    let fields: UserProfilFields
}

// Modèle pour les champs d'un profil utilisateur
struct UserProfilFields: Identifiable, Decodable {
    var id = UUID()
    let username: String
    let mail: String
    let criteria: [String]?
    let profile_picture: [ProfilPicture]?
    let POI: [String]?
    let password: String
    let ID: String
    let POT: [String]?
    
    enum CodingKeys: String, CodingKey {
        case username
        case mail
        case criteria
        case profile_picture
        case POI
        case password
        case ID
        case POT
    }
}

// Modèle pour une photo de profil
struct ProfilPicture: Decodable {
    let id: String
    let width: Int
    let height: Int
    let url: String
    let filename: String
    let size: Int
    let type: String
    let thumbnails: Thumbnails
}

// Modèle pour les vignettes de l'image
struct Thumbnails: Decodable {
    let small: Thumbnail
    let large: Thumbnail
    let full: Thumbnail
}

// Modèle pour une vignette
struct Thumbnail: Decodable {
    let url: String
    let width: Int
    let height: Int
}




// Modèle pour la réponse contenant les enregistrements de profils utilisateurs
struct CriteriaResponse: Decodable {
    let id: String
    let createdTime: String
    let fields: CriteriaFields
}

// Modèle pour les champs d'un profil utilisateur
struct CriteriaFields: Identifiable, Decodable {
    var id = UUID()
    let step: Bool
    let steepSlope: Bool
    let insufficientTactileIndicators: Bool
    let narrowPassage: Bool
    let auditorySignals: Bool
    let stair: Bool
    let surfaceProblems: Bool
    let userDataLog: [String]
    let noisyArea: Bool
    let userID: Int
    
    enum CodingKeys: String, CodingKey {
        case step
        case steepSlope = "steep_slope"
        case insufficientTactileIndicators = "insufficient_tactile_indicators"
        case narrowPassage = "narrow_passage"
        case auditorySignals = "auditory_signals"
        case stair
        case surfaceProblems = "surface_problems"
        case userDataLog = "UserData Log"
        case noisyArea = "noisy_area"
        case userID = "ID"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        step = try container.decodeIfPresent(Bool.self, forKey: .step) ?? false
        steepSlope = try container.decodeIfPresent(Bool.self, forKey: .steepSlope) ?? false
        insufficientTactileIndicators = try container.decodeIfPresent(Bool.self, forKey: .insufficientTactileIndicators) ?? false
        narrowPassage = try container.decodeIfPresent(Bool.self, forKey: .narrowPassage) ?? false
        auditorySignals = try container.decodeIfPresent(Bool.self, forKey: .auditorySignals) ?? false
        stair = try container.decodeIfPresent(Bool.self, forKey: .stair) ?? false
        surfaceProblems = try container.decodeIfPresent(Bool.self, forKey: .surfaceProblems) ?? false
        userDataLog = try container.decodeIfPresent([String].self, forKey: .userDataLog) ?? []
        noisyArea = try container.decodeIfPresent(Bool.self, forKey: .noisyArea) ?? false
        userID = try container.decode(Int.self, forKey: .userID)
    }
}


// Modèle pour la réponse contenant les enregistrements des points d'intérêt
struct POTResponse: Decodable {
    let records: [POTRecord]
}

// Modèle pour un enregistrement de point d'intérêt
struct POTRecord: Identifiable, Decodable {
    let id: String
    let createdTime: String
    let fields: POTFields
}

// Modèle pour les champs d'un point d'intérêt
struct POTFields: Identifiable, Decodable {
    var id = UUID()
    let tag: [String]?
    let description: String
    let latitude: Double
    let longitude: Double
    let image: [POTImage]?
    let userDataLog: [String]
    let altitude: Double
    let address: String
    let duration: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case tag
        case description
        case latitude
        case longitude = "longtitude"
        case image
        case userDataLog = "UserData Log"
        case altitude
        case address
        case duration
        case name
    }
}

// Modèle pour une image de point d'intérêt
struct POTImage: Decodable {
    let id: String
    let width: Int
    let height: Int
    let url: String
    let filename: String
    let size: Int
    let type: String
    let thumbnails: POTThumbnails
}

// Modèle pour les vignettes de l'image
struct POTThumbnails: Decodable {
    let small: POTThumbnail
    let large: POTThumbnail
    let full: POTThumbnail
}

// Modèle pour une vignette
struct POTThumbnail: Decodable {
    let url: String
    let width: Int
    let height: Int
}



struct POIResponse: Decodable {
    let records: [POIRecord]
}

struct POIRecord: Identifiable, Decodable {
    let id: String
    let createdTime: String
    let fields: POIFields
}

struct POIFields: Identifiable, Decodable {
    var id = UUID()
    let picture: [POIImage]?
    let type: [String]
    let description: String?
    let address: String
    let altitude: Double?
    let userDataLog: [String]
    let name: String
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case picture
        case type
        case description
        case address
        case altitude
        case userDataLog = "UserData Log"
        case name
        case latitude
        case longitude = "longtitude" 
    }
}
struct POIImage: Decodable {
    let id: String
    let width: Int
    let height: Int
    let url: String
    let filename: String
    let size: Int
    let type: String
    let thumbnails: POIThumbnails
}

struct POIThumbnails: Decodable {
    let small: POIThumbnail
    let large: POIThumbnail
    let full: POIThumbnail
}

struct POIThumbnail: Decodable {
    let url: String
    let width: Int
    let height: Int
}
