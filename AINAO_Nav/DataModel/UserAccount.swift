//
//  UserAccount.swift
//  AINAO Nav
//
//  Created by FrancoisW on 23/06/2024.
//

import Foundation
import SwiftData
import SwiftUI


import Foundation
// Removed import SwiftData as it's not a standard library and its usage is not shown
import SwiftUI

// Corrected the protocol declaration syntax
protocol ANAIOAccount{

    
    // Function used to create a new user account in the database, needs to verify that no user with same email address already exists
    // Needs to hash the password and store it in the database, password isn't stored in the app
    // The function returns a reference (unique id) of the user in the database
    // Criterias, even if empty must be created
    // RETURN: the userRef in the database if user is successully created : main cause of error is that user already exists thus this function needs to check that
    // QUESTION : Is there a mean in the database to check unicity of records based on one of their fields ?
    func createUser(id: UUID, username: String, mail: String, password: String) -> String?

    
    // Return l'ID de l'utilisateur et si l'utilisateur est déjà inscrit il return Nil
    
    
    // Nil if network problem or user doesn't exist
    func getUserCriteriaRef (userRef: String) -> String?
//    @StateObject var userViewModel = UserData()
//    @StateObject var criteriaViewModel = CriteriaData()
//        let _ = await userViewModel.addUserModel(id: id)
//        let user = userViewModel.userProfilModel
//        if let criteriaIDs = user?.fields.criteria {
//            for criteriaID in criteriaIDs {
//                await criteriaViewModel.addUserModel(id: criteriaID)
//        } else {
//            print("Aucun critère trouvé")
//        }
    // This function checks if an email already exists in the User Table of the database
    // RETURN : true if emal exists else returns false
    func doesEmailExists(email: String) -> Bool
    
    //isUserAlreadyRegistered(mail: String, json: String?)
    // Return True or False
    
    /*
        This function verifies that the user is in the database and that the password is correct
        RETURN : nil if operation failed, userRef if operation succeedded
     */
    func verifyUser(email: String, password: String) -> String?
    
    //checkLogging(email: String, password: String)
    // Return UserID or Nil
    
    
    
    /*
        Detele a user from the database (i.e. delete its records in the User Data Table )
        Criteria, POIs and POTs created by the user SHALL NOT be affected by this operation (update of these will be performed elsewhere)
        RETURN: True if operation suceeded (on reason why didn"t succeeded is user not ion database or database access problem
     */
    func deleteUser(userRef: String) -> Bool
    
    //deleteRecordAirTable(id: String)
    // Return True or False
    
    func deleteUserCriteria(criteriaRef: String) -> Bool
    // deleteCriteriaData(id: String)
    // Return True or False
    // Attention avec cette méthode car si on supprime ces critères l'utilisateur va ce retrouver sans critère
    // relié dans la base
 
}

protocol AINAODataBase {
    // This function needs to be called prior any attempts to use other func of the database
    // RETURN: true if successfull, false if operation failes (network error, database already created, ...)
    func initDataBase(token : String, databaseRootURL: String) -> Bool

    // This function returns the Date the database has been updated the last time
    func lastUpdate() -> Date
    
    /*
        This function updates a userprofile
        RETURN : true if succeeded, false if something went wrong
     */
    func updateUserProfile(userRef : String, username : String?, profilePicture : Image?, criteria : CriteriaSet?, longitudeDelta : Double?, latitudeDelta : Double?) -> Bool
        //updateRecordAirTable(id: String, json: String?)

    /*
        Add a POI, returns the ref is successfull. The POI needs to be created and also the User Profile needs to be updated to add the POI to its list of POI
        QUESTION : How to do that ? Is there an automated way ?
     */
    func addPOI(userRef : String, poi : POI) -> String?
    
    /*
        Add a POT, returns the ref is successfull. The POT needs to be created and also the User Profile needs to be updated to add the POT to its list of POT
        QUESTION : How to do that ? Is there an automated way to manage bi-directional relationship between POT and User?
     */
    func addPOT(userRef : String, pot : POT) -> String?
    
    /*
        Add a Route, returns the ref is successfull. The Route needs to be created and also the User Profile needs to be updated to add the Route to its list of Route
        QUESTION : How to do that ? Is there an automated way ?
     */
    func addRoute(userRef : String, route : Route) -> String?
    
    /*
        Modify a POI,POT or Route, for the momment, userRef isn't used, we don't check that the modifier is the ownner
     // CAUTION the original author remains the owner of the record, links shall not be changed
     // QUESTION : check that there isn't any problem
     */
    func modifyPOI(userRef : String, poiRef : String, poi : POI) -> Bool
    func modifyPOT(userRef : String, potRef : String, pot : POT) -> Bool
    func modifyRoute(userRef : String, routeRef : String, route : Route) -> Bool

    /*
        Modify a POI,POT or Route, for the momment, userRef isn't used, we don't check that the modifier is the ownner
     // CAUTION the original author remains the owner of the record, links shall not be changed
     // QUESTION : check that there isn't any problem
     */
    func deletePOI(userRef : String, poiRef : String, poi : POI) -> Bool
    func deletePOT(userRef : String, potRef : String, pot : POT) -> Bool
    func deleteRoute(userRef : String, routeRef : String, route : Route) -> Bool
    
    // This function gets all the POIs and POTs of the DataBase
    func getPOIs() -> [POI]
    func getPOTs() -> [POT]
    func getUserProfile(userRef: String) -> (Bool, UserProfileRestore?)


}



class UserProfileRestore {
    var id : UUID
    var username: String
    var mail: String
    var profilePicture: Image?
    var criteria: CriteriaSet?
    var location: (longitudeMeters: Double, latitudeMeters: Double)?
    
    init(id: UUID, username: String, mail: String, profilePicture: Image? = nil, criteria: CriteriaSet? = nil, location: (longitudeMeters: Double, latitudeMeters: Double)? = nil) {
        self.id = id
        self.username = username
        self.mail = mail
        self.profilePicture = profilePicture
        self.criteria = criteria
        self.location = location
    }
}


extension UserData {

    
    // ANAIOAccount protocol stubs
    func createUser(id: UUID, username: String, mail: String, password: String) async -> String? {
        var result: String? = nil // This will hold the result of the asynchronous operation


            if let userDataString = await addUserData(id: id, username: username, mail: mail, password: password) {
                result = userDataString // Set the local variable if the operation was successful

            }
            // After the task is completed, assign the local variable to the captured variable
            //      DispatchQueue.main.async {
              //  result = taskResult
        //        print("We DON'T SIGNAL the semaphore (set result to \(result)))"

        //        semaphore.signal() // Signal the semaphore once the assignment is done
         //   }
        //}

        // print("WE DON'T WAIT for end OF addUserData, we return (result = \(result)")
  //      semaphore.wait() // Wait for the signal before continuing
        return result // Return the result of the user creation
    }

    func getUserCriteriaRef(userRef: String) -> String? {
        // Implementation goes here
        return nil
    }
    
    func doesEmailExists(email: String) -> Bool {
        // Implementation goes here
        return true
    }
    
    func verifyUser(email: String, password: String) -> String? {
        // Implementation goes here
        return nil
    }
    
    func deleteUser(userRef: String) -> Bool {
        // Implementation goes here
        return true
    }
    
    func deleteUserCriteria(criteriaRef: String) -> Bool {
        // Implementation goes here
        return true
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
    
    func updateUserProfile(userRef: String, username: String?, profilePicture: Image?, criteria: CriteriaSet?, longitudeDelta: Double?, latitudeDelta: Double?) -> Bool {
        // Implementation goes here
        return true
    }
    
    func addPOI(userRef: String, poi: POI) -> String? {
        // Implementation goes here
        return nil
    }
    
    func addPOT(userRef: String, pot: POT) -> String? {
        // Implementation goes here
        return nil
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
    
    func deletePOI(userRef: String, poiRef: String, poi: POI) -> Bool {
        // Implementation goes here
        return true
    }
    
    func deletePOT(userRef: String, potRef: String, pot: POT) -> Bool {
        // Implementation goes here
        return true
    }
    
    func deleteRoute(userRef: String, routeRef: String, route: Route) -> Bool {
        // Implementation goes here
        return true
    }
    
    // This function gets all the POIs and POTs of the DataBase
    func getPOIs() -> [POI] {
        let poi = [POI]()
        return poi
    }
    func getPOTs() -> [POT] {
        let pot = [POT]()
        return pot
    }
    
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

}



class UserAccount {
    private(set) var userRef: String?    // Reference of the user in the database
     private(set) var name: String?
     private(set) var email: String?
     private(set) var isSignedIn: Bool
     private(set) var isInitialized: Bool
     var userData: AllModel // Struct in the dataBase manager

    // Set functions for the private(set) properties
      func setUserRef(_ newRef: String) {
          self.userRef = newRef
      }

      func setName(_ newName: String) {
          self.name = newName
          saveUserAccountToPersistentStorage()
      }

      func setEmail(_ newEmail: String) {
          self.email = newEmail
          saveUserAccountToPersistentStorage()

      }

      func setSignInStatus(_ status: Bool) {
          self.isSignedIn = status
          saveUserAccountToPersistentStorage()

      }

      func setInitializationStatus(_ status: Bool) {
          self.isInitialized = status
          saveUserAccountToPersistentStorage()
      }

    init(name: String? = nil, email: String? = nil, password: String? = nil, isInitialized: Bool? = false, isSignedIn : Bool? = false) {
        self.name = name
        self.email = email
        self.userData = AllModel()
        self.isSignedIn = isSignedIn ?? false
        self.isInitialized = isInitialized ?? false
        
        /* Finish the initialization from perisistent storage */
        loadUserAccountFromPersistentStorage()
    }

    private func loadUserAccountFromPersistentStorage()  {
        self.userRef = UserDefaults.standard.string(forKey: "userRef") ?? nil
        self.name = UserDefaults.standard.string(forKey: "userName") ?? nil
        self.email = UserDefaults.standard.string(forKey: "userEmail") ?? nil
        self.isSignedIn = UserDefaults.standard.bool(forKey: "isSignedIn")
        self.isInitialized = UserDefaults.standard.bool(forKey: "isInitialized")
        
        
            print("loadUserAccountFromPersistentStorage")
            print("User Reference: \(userRef ?? "nil")")
            print("Name: \(name ?? "nil")")
            print("Email: \(email ?? "nil")")
            print("Signed In: \(isSignedIn)")
            print("Initialized: \(isInitialized)")
        
        
    }

    
    private func saveUserAccountToPersistentStorage() {
        UserDefaults.standard.set(self.userRef, forKey: "userRef")
        UserDefaults.standard.set(self.name, forKey: "userName")
        UserDefaults.standard.set(self.email, forKey: "userEmail")
        UserDefaults.standard.set(self.isSignedIn, forKey: "isSignedIn")
        UserDefaults.standard.set(self.isInitialized, forKey: "isInitialized")
    }

    // Existing properties and initializer...

    // Corrected the variable names to match Swift's naming convention
    func createUser(id: UUID, name: String, email: String, password: String) async  -> Bool {
        
        
        if (isInitialized) {return false} // cannot have two user signed in at the same time
        
        self.name = name // use self to distinguish property from argument
        self.email = email
        
        
        userRef = await userData.createUser(id: id, username: name, mail: email, password: password)
    
        // Set isInitialized to true if userRef is non-nil
        isInitialized = userRef != nil
        
        // Return true if user was successfully created (userRef is non-nil)
        return isInitialized
    }

    func verifyUser(email: String, password: String, userProfile: UserProfile) async -> Bool {
        var userProfileRestore : UserProfileRestore?
        var result : Bool = false
        
        if (!isInitialized) {return false} // Cannot verify not created account

        // Attempt to verify the user with the provided credentials
         if let userRef = await userData.verifyUser(email: email, password: password) {
             // If userRef is non-nil, set isSignedIn to true and return true
             isSignedIn = true
             
             print("User : \(email) Successfully verified (ref=\(userRef)")
             (result,userProfileRestore) = await  userData.getUserProfile(userRef: userRef)

             
             
             if (result) {
            
                 userProfile.userAccount.name = userProfileRestore!.username
                 userProfile.userAccount.email = userProfileRestore!.mail
                 
                 if let profilePicture = userProfileRestore!.profilePicture {
                         userProfile.profileImage = AppImage(image: profilePicture)
                     } else {
                         userProfile.profileImage = AppImage(image: Image(systemName: "person.fill"))
                     }
                 
                 userProfile.id = userProfileRestore!.id
                 // TODO
                 //userProfile._criteriaSet = userProfileRestore!.criteria
                 return true

     
             } else {
                fatalError("Unable to restore the profile")
             }
                 
             
         } else {
             // If userRef is nil, set isSignedIn to false and return false
             isSignedIn = false
             return false
         }

    }
    
    func deleteUser() async -> Bool{
        if (!isInitialized || userRef == nil) { return false } // Cannot verify not created account or userRef is nil

        
        let result = await  userData.deleteUser(userRef: userRef!) // if initialized

        isInitialized = false
        userRef = nil
        return result
    }
    
    func logoutUser() -> Bool {
        if (!isInitialized || userRef == nil) { return false } // Cannot logout not created account or userRef is nil
        // Nothing performed on the database itself0
        isSignedIn = false
        return true
    }

}
