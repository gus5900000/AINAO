//
//  Data.swift
//  AINAO_Nav
//
//  Created by Apprenant 101 on 01/07/2024.
//

import Foundation
import SwiftUI


class AllModel: ObservableObject {
    var userViewModel = UserData()
    var userModel = UserData()
    var criteriaModel = CriteriaData()
    var POTModel = POTDataAPI()
    var POIModel = POIDataAPI()
    
}


extension AllModel {

    
    func createUser(id: UUID, username: String, mail: String, password: String) async -> String? {
        
        var result: String? = nil
        if let userDataString = await userModel.addUserData(id: id, username: username, mail: mail, password: password) {
            result = userDataString // Set the local variable if the operation was successful
        }
        return result
    }

    func getUserCriteriaRef(userRef: String) async -> String? {
        if await userModel.addUserModel(id: userRef) {
            return userModel.userProfilModel?.id
        }
        return nil
    }
    
    func doesEmailExists(email: String) async -> Bool {
        
        var result: Bool = false
        if let userDataString = await userModel.isUserAlreadyRegistered(mail: email, json: nil) {
            result = userDataString // Set the local variable if the operation was successful
        }
        return result
    }
    
    func verifyUser(email: String, password: String) async -> String? {
        
        var result: String? = nil // This will hold the result of the asynchronous operation
        if let userDataString = await userModel.checkLogging(email: email, password: password) {
            result = userDataString // Set the local variable if the operation was successful
        }
        return result // Return the result of the logging check
    }
    
    func deleteUser(userRef: String) async -> Bool {
        
        var result: Bool = false // This will hold the result of the asynchronous operation
        if let userDataString = await userModel.deleteUserData(id: userRef) {
            result = userDataString // Set the local variable if the operation was successful
        }
        return result // Return the result of the deletion operation
    }

    
    func deleteUserCriteria(criteriaRef: String) async -> Bool {
        var result: Bool = false // This will hold the result of the asynchronous operation
        
        if let userDataString = await criteriaModel.deleteCriteriaData(id: criteriaRef) {
            result = userDataString // Set the local variable if the operation was successful
        }
        return result // Return the result of the deletion operation
    }
    
    // AINAODataBase protocol stubs
    func initDataBase(token: String, databaseRootURL: String) -> Bool {
        // Implementation goes here
        return true
    }
    
    func lastUpdate() -> Date {
        // Implementation goes here
        return Date()
    }
    
    func updateUserProfile(userRef: String, username: String?, profilePicture: Image?, criteria: CriteriaSet?, longitudeDelta: Double?, latitudeDelta: Double?) async -> Bool {
        
        let result = await userModel.updateUserData(
            id: userRef,
            username: username,
            mail: nil,
            password: nil,
            pictureID: nil,
            criteriaID: nil,
            poiID: nil,
            potID: nil
        )
        
        return result
    }
    
    func addPOI(userRef: String, poi: POI) async -> String? {
        //Alors si ça fonctionne c'est un miracle
        
        var result: String? = nil // This will hold the result of the asynchronous operation
        
        if let userDataString = await POIModel.addPOIData(name: poi.name ?? "", type: poi.type.rawValue, longitude: poi.longitude, latitude: poi.latitude, address: poi.address ?? "", picture: poi.image, description: poi.description, userDataID: userRef) 
        {
            result = userDataString // Set the local variable if the operation was successful
        }
        
        return result // Return the result of the deletion operation
    }
    
    func addPOT(userRef: String, pot: POT) async -> String? {
        //Alors si ça fonctionne c'est un miracle
        var result: String? = nil // This will hold the result of the asynchronous operation
        
        print("\(pot.type.rawValue)")
        
        
      //  print("\(POType.)")

        if let userDataString = await POTModel.addPOTData(name: pot.name ?? "",
                                                        //  tag: [pot.potType.enumName],
                                                          tag: ["narrow_passage"],
 longtitude: pot.longitude,
                                                          latitude: pot.latitude,
                                                          address: pot.address ?? "",
                                                          image: nil,
                                                          description: pot.description,
                                                          userDataID: [userRef])
        {
            result = userDataString // Set the local variable if the operation was successful
        }
        return result // Return the result of the deletion operation
    }
    
    func addRoute(userRef: String, route: Route) -> String? {
        // Implementation goes here
        return nil
    }
    
    func modifyPOI(userRef: String, poiRef: String, poi: POI) -> Bool {
        // Implementation goes here
        return true
    }
    
    func modifyPOT(userRef: String, potRef: String, pot: POT) -> Bool {
        // Implementation goes here
        return true
    }
    
    func modifyRoute(userRef: String, routeRef: String, route: Route) -> Bool {
        // Implementation goes here
        return true
    }
    
    func deletePOI(userRef: String, poiRef: String, poi: POI) async -> Bool {
        
        var result: Bool = false // This will hold the result of the asynchronous operation
        if let userDataString = await POIModel.deletePOIData(id: userRef) {
            result = userDataString // Set the local variable if the operation was successful
        }
        return result // Return the result of the deletion operation
    }
    
    func deletePOT(userRef: String, potRef: String, pot: POT) async -> Bool {
        
        var result: Bool = false // This will hold the result of the asynchronous operation
        
        if let userDataString = await POTModel.deletePOTData(id: userRef) {
            result = userDataString // Set the local variable if the operation was successful
        }
        return result // Return the result of the deletion operation
    }
    
    func deleteRoute(userRef: String, routeRef: String, route: Route) -> Bool {
        // Implementation goes here
        return true
    }
    
    // This function gets all the POIs and POTs of the DataBase
    func getPOIs() async  -> [POI] {
        
        var result: [POI] = [] // This will hold the result of the asynchronous operation
        let _  = await POIModel.addPOIModel()
        
        // exemple POI.Type = fields.type
        return result
    }
    
    func getPOIsUser(userRef: String) async -> [POI] {
        let poi = [POI]()
        return poi
    }
    
    func getPOTs() -> [POT] {
        let pot = [POT]()
        return pot
    }
    func getPOTsUser(userRef: String) -> [POT] {
        let pot = [POT]()
        return pot
    }
    
    func getUserProfile(userRef: String) async -> (Bool, UserProfileRestore?) {
        // Your logic to fetch and fill the profile data
        var isSuccess = true
        var profile = UserProfileRestore(id : UUID(),username : "Clint Eastwood", mail : "clint@hollywood.com" )

        isSuccess = await userModel.addUserModel(id: userRef)

        if isSuccess {
            // Example of filling the data
            profile.username = userModel.userProfilModel?.fields.username ?? ""
            profile.mail = userModel.userProfilModel?.fields.mail ?? ""
            
            // TODO: Fill the rest of the profile data
            //profile.criteria = userViewModel.userProfilModel?.fields.criteria // Moi je renvoie un [String] toi tu recois un CriteriaSet
            // TODO: Moi je stock une URL et toi tu attends une Image?
            //
            //profile.profilePicture =  userViewModel.userProfilModel?.fields.profile_picture?.first?.url ?? ""
            profile.location = (longitudeMeters: 50.0, latitudeMeters: 3.0)
        }
        
        // Return a tuple containing the success status and the filled profile
        return (isSuccess, profile)
    }
    
    /*
    func getUserProfile(userRef: String) -> (Bool, UserProfileRestore?) {
        // Your logic to fetch and fill the profile data
        let uuidString = "FFFFF000-0000-0000-0000-000000000000" // Example UUID string

        var profile = UserProfileRestore(id : UUID(uuidString: uuidString)!,username : "Clint Eastwood", mail : "clint@hollywood.com" )

        // Example of filling the data
        profile.profilePicture = Image("clint")
        profile.criteria = CriteriaSet()
        profile.location = (longitudeMeters: 50.0, latitudeMeters: 3.0)

        // Check if the necessary data is filled
        let isSuccess = profile.profilePicture != nil
        
        // Return a tuple containing the success status and the filled profile
        return (isSuccess, profile)
    }
     */

}




struct LoginModel {
    var screenStart: Bool = false
    var screenMiddle: Bool = false
    var screenEnd: Bool = false
}
