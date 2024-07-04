//
//  UserProfile.swift
//  EatSideStory
//
//  Created by FrancoisW on 16/06/2024.
//

import Foundation
import SwiftData
import MapKit
import SwiftUI


@Observable
class UserProfile {
    
    
    var id : UUID
    var userAccount : UserAccount // Account shall be created even if not initialized
    var profileImage : AppImage
    var points : Int = 525
    var latestPosition : Placemark // Most of the time this is the current position, this is the latest is GPS isn't working
    
    private var latitudeDelta : Double
    private var longitudeDelta : Double // The user may like come back to these defaults settings when on a new machine
    
    private var _POTs: [POT]
    private var _POIs: [POI]
    private var _routeHistory: [Route]
     var _criteriaSet: CriteriaSet //
    

    init(
        id: UUID = UUID(),
        userAccount: UserAccount = UserAccount(),
        profileImage: AppImage = AppImage(image : Image(systemName: "person.fill")),
      //  points : Int = 525,
        latestPosition: Placemark = Placemark(),
        latitudeDelta: Double = Consts.Map.defaultLatitudeDelta,
        longitudeDelta: Double = Consts.Map.defaultLongitudeDelta,
        POTs: [POT] = [],
        POIs: [POI] = [],
        routeHistory: [Route] = [],
        criteriaSet: CriteriaSet = CriteriaSet()
    ) {
        self.id = id
        self.userAccount = userAccount
                      
        self.profileImage = profileImage
 //       self.points = points

        self.latestPosition = latestPosition
        self.latitudeDelta = latitudeDelta
        self.longitudeDelta = longitudeDelta
        self._POTs = POTs
        self._POIs = POIs
        self._routeHistory = routeHistory
        self._criteriaSet = criteriaSet
        
        // Call loadFromPersistentStorage() after all properties are initialized
        //
        loadUserProfileFromPersistentStorage()

    }
    private func loadUserProfileFromPersistentStorage() {
        if let userIdString = UserDefaults.standard.string(forKey: "userID") {
            print("userID key found : \(userIdString)")
           if let unwrappedId = UUID(uuidString: userIdString) {
             self.id = unwrappedId
           } else {
             // Handle invalid UUID string format in userIdString
             print("Error: Invalid UUID format in UserDefaults")
             self.id = UUID() // Create a new UUID as a fallback
             UserDefaults.standard.set(self.id.uuidString, forKey: "userID")
           }
         } else {
           // Handle case where userIdString is nil

             self.id = UUID()
             print("userID key Not found, new one created and stored : \(self.id)")

           UserDefaults.standard.set(self.id.uuidString, forKey: "userID")
         }
    }
    
    private func saveUserProfileToPersistentStorage() {
        UserDefaults.standard.set(self.id.uuidString, forKey: "userID")
    }
    
    func setId(_ newId: UUID) {
        self.id = newId
        saveUserProfileToPersistentStorage()
    }


    // Public getters
     var POTs: [POT] {
         return _POTs
     }

     var POIs: [POI] {
         return _POIs
     }

     var routeHistory: [Route] {
         return _routeHistory
     }
    
    var criteria: [Criterion] {
        return _criteriaSet.criteriaArray
    }
 

    func addPOT(with pot: POT) async {
        if !userAccount.isSignedIn {
            print("Error: User not logged in")
            return
        }

        var pots = POTs
        
        pots.append(pot)
        await updatePOTs(with: pots)
    }

    func addPOI(with poi: POI) async {
        if !userAccount.isSignedIn {
            print("Error: User not logged in")
            return
        }

        var pois = POIs
        
        pois.append(poi)
        await updatePOIs(with: pois)
    }


    // Methods to update properties internally
    func updatePOTs(with newPOTs: [POT]) async {
        if !userAccount.isSignedIn {
            print("Error: User not logged in")
            return
        }
        
        guard let currentUserRef = userAccount.userRef else {
            print("Error: User reference not found")
            return
        }
        
        // Find POTs to add by checking if they're not in the current list
        let potsToAdd = newPOTs.filter { newPOT in
            !_POTs.contains { $0.id == newPOT.id }
        }
        
        // Find POTs to delete by checking if they're not in the new list
        let potsToDelete = _POTs.filter { oldPOT in
            !newPOTs.contains { $0.id == oldPOT.id }
        }
        
        // Assuming potsToAdd is an array of POT objects and userAccount.userData.addPOT is an async function
        for pot in potsToAdd {
            if let dbRef = await userAccount.userData.addPOT(userRef: currentUserRef, pot: pot) {
                pot.dbRef = dbRef
            } else {
                print("ERROR : Unable to add new POT in database")
                // Handle the error appropriately
                // For example, you might want to break the loop or collect the errors in an array
                break
            }
        }

        // Assuming potsToDelete is an array of POT objects and userAccount.userData.deletePOT is an async function
        for pot in potsToDelete {
            guard let dbRef = pot.dbRef else {
                print("ERROR : POT in the database with non assigned ref")
                // Handle the error appropriately
                continue // Skip this iteration and proceed with the next one
            }

            if await userAccount.userData.deletePOT(userRef: currentUserRef, potRef: dbRef, pot: pot) {
                print("POT deleted: \(dbRef)")
            } else {
                print("Failed to delete POT: \(dbRef)")
                // Handle the failure appropriately
                // For example, you might want to break the loop or collect the errors in an array
                break
            }
        }

        // Update the local list of POTs with the new list
        _POTs = newPOTs


    }

    func updatePOIs(with newPOIs: [POI]) async {
        if !userAccount.isSignedIn {
            print("Error: User not logged in")
            return
        }

        guard let currentUserRef = userAccount.userRef else {
            print("Error: User reference not found")
            return
        }

        // Find POIs to add
        let poisToAdd = newPOIs.filter { newPOI in
            !_POIs.contains { $0.id == newPOI.id }
        }

        // Find POIs to delete
        let poisToDelete = _POIs.filter { oldPOI in
            !newPOIs.contains { $0.id == oldPOI.id }
        }

        
        // Assuming poisToAdd is an array of POI objects and userAccount.userData.addPOI is an async function
        for poi in poisToAdd {
            if let dbRef = await userAccount.userData.addPOI(userRef: currentUserRef, poi: poi) {
                poi.dbRef = dbRef
            } else {
                print("ERROR : Unable to add new POI in database")
                // Handle the error appropriately
                // For example, you might want to break the loop or collect the errors in an array
                break
            }
        }

        
        

        // Assuming poisToDelete is an array of POI objects and userAccount.userData.deletePOI is an async function
        for poi in poisToDelete {
            guard let dbRef = poi.dbRef else {
                print("ERROR : POI in the database with non assigned ref")
                // Handle the error appropriately
                continue // Skip this iteration and proceed with the next one
            }

            if await userAccount.userData.deletePOI(userRef: currentUserRef, poiRef: dbRef, poi: poi) {
                print("POI deleted: \(dbRef)")
            } else {
                print("Failed to delete POI: \(dbRef)")
                // Handle the failure appropriately
                // For example, you might want to break the loop or collect the errors in an array
                break
            }
        }

        // Update the local list of POIs with the new list
        _POIs = newPOIs
    }

    func updateRouteHistory(with newRouteHistory: [Route]) {
        if !userAccount.isSignedIn {
            print("Error: User not logged in")
            return
        }

        guard let currentUserRef = userAccount.userRef else {
            print("Error: User reference not found")
            return
        }

        // Find Routes to add
        let routesToAdd = newRouteHistory.filter { newRoute in
            !_routeHistory.contains { $0.id == newRoute.id }
        }

        // Find Routes to delete
        let routesToDelete = _routeHistory.filter { oldRoute in
            !newRouteHistory.contains { $0.id == oldRoute.id }
        }

        // Update the database by adding new Routes and storing their dbRefs
        routesToAdd.forEach { route in
            if let dbRef = userAccount.userData.addRoute(userRef: currentUserRef, route: route) {
                route.dbRef = dbRef
            } else {
                print("ERROR : Unable to add new Route in database")
                return
            }
        }

        // Update the database by deleting old Routes using their dbRefs
        routesToDelete.forEach { route in
            if (route.dbRef == nil) {
                print("ERROR : Route in the database with non assigned ref")
                return
            }
            if userAccount.userData.deleteRoute(userRef: currentUserRef, routeRef: route.dbRef!, route: route) {
                print("Route deleted: \(route.dbRef)")
            } else {
                print("Failed to delete Route: \(route.dbRef)")
                return
            }
        }

        // Update the local list of Route History with the new list
        _routeHistory = newRouteHistory
    }


    func updateCriteriaSet(with modifiedTable: [Criterion]) async {
        if (!userAccount.isSignedIn) {
            print("Error setCriteriaSet, User not logged")
            return
        }
        
        do {
            try _criteriaSet.updateCriteria(with: modifiedTable)
        } catch {
            // Handle the error, e.g., log it or show an error message to the user
            // TODO In production, we should achieve a better user experience
            fatalError("UserProfile() : An unrecoverable error occurred: \(error)")
        }
        
        // Here we can force unwrapping userRef since the user is signed in
        // TODO : we should check the result of the update and act accordingly
        let _ = await userAccount.userData.updateUserProfile(userRef : userAccount.userRef!, username: nil, profilePicture: nil, criteria: self._criteriaSet, longitudeDelta: nil,latitudeDelta: nil)
    }
    
    init(
        id: UUID? = nil,
        userAccount: UserAccount? = nil,
        profileImage: AppImage? = nil,
        latestPosition: Placemark? = nil,
        latitudeDelta: Double? = nil,
        longitudeDelta: Double? = nil,
        POTs: [POT]? = nil,
        POIs: [POI]? = nil,
        routeHistory: [Route]? = nil,
        criteriaSet: CriteriaSet? = nil,
        unifiedMapItems: [UnifiedMapItem]?=nil) {
            
            self.id = id ?? UUID()
            self.userAccount = userAccount ?? UserAccount()
            self.profileImage = profileImage ?? AppImage(image : Image("folder.badge.person.crop"))
            self.latestPosition = latestPosition ?? Placemark()
            self.latitudeDelta = latitudeDelta ?? Consts.Map.defaultLatitudeDelta
            self.longitudeDelta = longitudeDelta ?? Consts.Map.defaultLongitudeDelta
            self._POTs = POTs ?? []
            self._POIs = POIs ?? []
            self._routeHistory = routeHistory ?? []
            self._criteriaSet = criteriaSet ?? CriteriaSet()
        }
    
    var region: MKCoordinateRegion? {
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latestPosition.latitude, longitude: latestPosition.longitude),
            span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        )
    }
    
}




extension UserProfile {
    func dummyInit() {
        
        let pp1 = Placemark(name: "Simplon", address: "47 Rue Barthélémy Delespaul, 59000 Lille, France", latitude: 50.6242076, longitude: 3.0596525)
        let pp2 = Placemark(name: "Théatre Sébastopol", address: "Place Sébastopol, 59000 Lille,  France", latitude: 50.62939218513652, longitude: 3.058239728757164)
        let pp3 = Placemark(name: "Lille Flandres", address: "Lille, France", latitude: 50.636833996237286, longitude: 3.0699861455295046)
        let pp4 = Placemark(name: "Apple Lille", address: "1 Rue Faidherbe, 59000 Lille,  France", latitude: 50.63738517105418, longitude: 3.0657185557408337)
        let pp5 = Placemark(name: "Maison", address: "62 Rue de Menin, 7732, Estaimpuis, Belgique", latitude: 50.71154841530979, longitude: 3.2473586395166003)
        
        
        
        
        // Création des instances de POI avec des descriptions combinées
        var tmpPOIs : [POI] = [
            POI(type: .toilets, sourceRef: id, sourceType: .currentUser, description: "Simplon, un lieu de formation en informatique dynamique et innovant. Toilettes publiques propres disponibles.", image: nil, placemark: pp1),
            POI(type: .bench, sourceRef: id, sourceType: .currentUser, description: "Théâtre Sébastopol, un théâtre historique offrant une programmation culturelle variée. Banc confortable pour se reposer devant le théâtre.", image: nil, placemark: pp2),
            POI(type: .coolDown, sourceRef: id, sourceType: .currentUser, description: "Gare Lille Flandres, la principale gare ferroviaire de Lille et un carrefour de l'activité de la ville. Zone de repos disponible pour les voyageurs.", image: nil, placemark: pp3),
            POI(type: .toilets, sourceRef: id, sourceType: .currentUser, description: "Apple Lille, le magasin phare d'Apple à Lille et un paradis pour les amateurs de technologie. Toilettes accessibles à l'intérieur pour les clients.", image: nil, placemark: pp4),
            POI(type: .bench, sourceRef: id, sourceType: .currentUser, description: "Maison, un endroit chaleureux et accueillant où le cœur se repose. Banc paisible à proximité pour profiter du calme.", image: nil, placemark: pp5)
        ]
        tmpPOIs.forEach {poi in
            self._POIs.append(poi)
        }
        
        // New Set of POIs
        let p1 = Placemark(name: "Parc Jean-Baptiste Lebas", address: "Boulevard Jean-Baptiste Lebas, 59000 Lille, France", latitude: 50.631912, longitude: 3.045883)
        let p2 = Placemark(name: "Musée d'Histoire Naturelle", address: "19 Rue de Bruxelles, 59000 Lille, France", latitude: 50.623104, longitude: 3.065819)
        let p3 = Placemark(name: "Gare Saint Sauveur", address: "17 Boulevard Jean-Baptiste Lebas, 59000 Lille, France", latitude: 50.632935, longitude: 3.057320)
        let p4 = Placemark(name: "La Piscine de Roubaix", address: "23 Rue de l'Espérance, 59100 Roubaix, France", latitude: 50.691585, longitude: 3.181418)
        let p5 = Placemark(name: "Le Palais des Beaux-Arts", address: "Place de la République, 59000 Lille, France", latitude: 50.632278, longitude: 3.062492)
        let p6 = Placemark(name: "Zoo de Lille", address: "Avenue Mathias Delobel, 59000 Lille, France", latitude: 50.632846, longitude: 3.042483)
        let p7 = Placemark(name: "Jardin Vauban", address: "Boulevard Vauban, 59800 Lille, France", latitude: 50.632289, longitude: 3.049586)
        let p8 = Placemark(name: "Marché de Wazemmes", address: "Place de la Nouvelle Aventure, 59000 Lille, France", latitude: 50.623157, longitude: 3.048073)
        let p9 = Placemark(name: "Maison Folie Wazemmes", address: "70 Rue des Sarrazins, 59000 Lille, France", latitude: 50.624927, longitude: 3.045776)
        let p10 = Placemark(name: "Le Tripostal", address: "Avenue Willy Brandt, 59000 Lille, France", latitude: 50.636073, longitude: 3.070376)
        
        
        
        let p26 = Placemark(name: "Château d'Estaimpuis", address: "Rue du Château, 7730 Estaimpuis, Belgique", latitude: 50.712345, longitude: 3.248976)
        let p27 = Placemark(name: "Église Saint-Pierre d'Estaimpuis", address: "Rue de l'Église, 7730 Estaimpuis, Belgique", latitude: 50.713456, longitude: 3.250987)
        let p28 = Placemark(name: "Parc du Château de Bourgogne", address: "Rue de Bourgogne, 7730 Estaimpuis, Belgique", latitude: 50.714567, longitude: 3.252098)
        let p29 = Placemark(name: "Moulin de la Marquise", address: "Rue du Moulin, 7730 Estaimpuis, Belgique", latitude: 50.715678, longitude: 3.253109)
        let p30 = Placemark(name: "Lac d'Estaimpuis", address: "Rue du Lac, 7730 Estaimpuis, Belgique", latitude: 50.716789, longitude: 3.254210)
        
        
        tmpPOIs  = [
            // Lille
            POI(type: .drinking_water, sourceRef: id, sourceType: .currentUser, description: "Le Parc Jean-Baptiste Lebas, un espace vert au cœur de Lille, offre aux visiteurs des points d'eau potable pour se désaltérer lors d'une promenade.", image: nil, placemark: p1),
            POI(type: .first_aid, sourceRef: id, sourceType: .currentUser, description: "Le Musée d'Histoire Naturelle, un lieu de découverte et d'émerveillement, dispose d'une trousse de premiers secours pour intervenir rapidement en cas de besoin.", image: nil, placemark: p2),
            POI(type: .coolDown, sourceRef: id, sourceType: .currentUser, description: "La Gare Saint Sauveur, ancienne gare transformée en espace culturel, propose des zones ombragées pour se rafraîchir durant les journées ensoleillées.", image: nil, placemark: p3),
            POI(type: .inclusive_culture, sourceRef: id, sourceType: .currentUser, description: "La Piscine de Roubaix, musée d'art et d'industrie, est accessible à tous et s'engage à promouvoir une culture inclusive.", image: nil, placemark: p4),
            POI(type: .interfaith_chapel, sourceRef: id, sourceType: .currentUser, description: "Le Palais des Beaux-Arts, en plus d'être un haut lieu de la culture, abrite un espace de recueillement ouvert à toutes les confessions.", image: nil, placemark: p5),
            POI(type: .drinking_water, sourceRef: id, sourceType: .currentUser, description: "Le Zoo de Lille, un espace de biodiversité en ville, offre aux visiteurs des points d'eau potable pour se désaltérer tout en découvrant la faune.", image: nil, placemark: p6),
            POI(type: .coolDown, sourceRef: id, sourceType: .currentUser, description: "Le Jardin Vauban, poumon vert de Lille, est l'endroit idéal pour se relaxer et profiter de la fraîcheur des espaces ombragés.", image: nil, placemark: p7),
            POI(type: .first_aid, sourceRef: id, sourceType: .currentUser, description: "Le Marché de Wazemmes, cœur battant de Lille, dispose d'un poste de premiers secours pour garantir la sécurité des chalands.", image: nil, placemark: p8),
            POI(type: .inclusive_culture, sourceRef: id, sourceType: .currentUser, description: "La Maison Folie Wazemmes, centre culturel dynamique, s'engage à promouvoir une culture ouverte et accessible à tous.", image: nil, placemark: p9),
            POI(type: .interfaith_chapel, sourceRef: id, sourceType: .currentUser, description: "Le Tripostal, lieu d'exposition post-industriel, inclut un espace de recueillement interconfessionnel pour les visiteurs en quête de tranquillité.", image: nil, placemark: p10),
            
            // Estaimpuis
            POI(type: .defibrillator, sourceRef: id, sourceType: .currentUser, description: "Le Château d'Estaimpuis, témoin de l'histoire locale, est équipé d'un défibrillateur pour intervenir en cas d'urgence cardiaque.", image: nil, placemark: p26),
            POI(type: .first_aid, sourceRef: id, sourceType: .currentUser, description: "L'Église Saint-Pierre d'Estaimpuis, monument historique, dispose d'une trousse de premiers secours pour les fidèles et les visiteurs.", image: nil, placemark: p27),
            POI(type: .coolDown, sourceRef: id, sourceType: .currentUser, description: "Le Parc du Château de Bourgogne, avec ses vastes étendues vertes, offre des zones de repos pour se rafraîchir lors des journées chaudes.", image: nil, placemark: p28),
            POI(type: .drinking_water, sourceRef: id, sourceType: .currentUser, description: "Le Moulin de la Marquise, patrimoine d'Estaimpuis, propose un accès à de l'eau potable pour les randonneurs et les touristes.", image: nil, placemark: p29),
            POI(type: .bench, sourceRef: id, sourceType: .currentUser, description: "Le Lac d'Estaimpuis, lieu de détente naturel, est doté de bancs confortables pour admirer la vue et se reposer.", image: nil, placemark: p30)
            
        ]
        
        // Add the rest of POIs
        tmpPOIs.forEach {poi in
            self._POIs.append(poi)
        }
        
        
    }
}
