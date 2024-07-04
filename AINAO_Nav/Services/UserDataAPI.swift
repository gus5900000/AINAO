//
//  UserLogging.swift
//  EatSideStory
//
//  Created by Apprenant 101 on 19/06/2024.
//

import Foundation
import CryptoKit


class UserData: ObservableObject {

    
    
    @Published var userProfilModel: UserProfilResponse? = nil
    private let apiKey = Consts.Services.airtableMainDBKey
    private let apiURL = Consts.Services.airtableMainDBImportRequest
    
    // Fonction asynchrone pour récupérer le JSON complet depuis l'API
    @MainActor
    func fetchUserData() async -> String? {
        //Permet de check si l'URL fonctionne et si oui le met dans l'objet URL
        guard let url = URL(string: apiURL) else {
            print("URL invalide")
            return nil
        }
        // Objet requête contenant des en-têtes ou d'autres métadonnées
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        do {
            // Exécute la requête et attend la réponse
            let (data, _) = try await URLSession.shared.data(for: request)
            // Décodage des données reçues en JSON
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            print("JSON complet: \(json)")
            // Convertit les données en chaîne UTF-8 et retourne le JSON en tant que String
            return String(data:data, encoding: .utf8)
        } catch {
            // Gestion des erreurs potentielles
            print(error.localizedDescription)
            print(error)
            return nil
        }
    }
    
    @MainActor
    func addUserModel(id: String) async -> Bool {
        //Permet de check si l'URL fonctionne et si oui le met dans l'objet URL
        guard let url = URL(string: "\(apiURL)/\(id)") else {
            print("URL invalide")
            return false
        }
        // Objet requête contenant des en-têtes ou d'autres métadonnées
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        do {
            // Exécute la requête et attend la réponse
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(data: data, encoding: .utf8)!)
            
            // Décodage ou conversion des données reçues au format UserProfileModel
            let decodedData = try JSONDecoder().decode(UserProfilResponse.self, from: data)
            
            self.userProfilModel = decodedData
            print("Données bien ajoutées à la liste")
            return true
        } catch {
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .typeMismatch(let type, let context):
                    print("Type mismatch error: \(type)")
                    print("Context: \(context)")
                case .valueNotFound(let type, let context):
                    print("Value not found error: \(type)")
                    print("Context: \(context)")
                case .keyNotFound(let key, let context):
                    print("Key not found error: \(key)")
                    print("Context: \(context)")
                case .dataCorrupted(let context):
                    print("Data corrupted error")
                    print("Context: \(context)")
                @unknown default:
                    print("Unknown decoding error")
                }
            } else {
                // Gestion des erreurs potentielles
                print(error.localizedDescription)
                print(error)
            }
            return false
        }
    }
    


    @MainActor
    func updateUserData(id: String, username: String?, mail: String?, password: String?, pictureID: String?, criteriaID: String?, poiID: String?, potID: String?) async -> Bool {
        
        guard let url = URL(string: "\(apiURL)/\(id)") else {
            print("URL invalide")
            return false
        }
        
        
        var fields: [String: Any] = ["ID": id]
        
        // Ajouter les champs optionnels seulement s'ils ne sont pas nil
        if let username = username {
            fields["username"] = username
        }
        
        if let mail = mail {
            fields["mail"] = mail
        }
        
        if let password = password {
            fields["password"] = hashPassword(password)
        }
        
        if let pictureID = pictureID {
            fields["profile_picture"] = [["id": pictureID]]
        }
        
        if let criteriaID = criteriaID {
            fields["criteria"] = [criteriaID]
        }
        
        if let poiID = poiID {
            fields["POI"] = [poiID]
        }
        
        if let potID = potID {
            fields["POT"] = [potID]
        }
        
        let jsonData: [String: Any] = ["fields": fields]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: jsonData) else {
            print("Erreur lors de la sérialisation des paramètres en JSON")
            return false
        }
        
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = postData
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                print("\(id) bien mis à jour")
                return true
            } else {
                print("Erreur dans la réponse du serveur: \(response)")
                return false
            }
        } catch {
            print("Erreur lors de l'encodage ou de l'envoi des données: \(error.localizedDescription)")
            return false
        }
    }
    
    
    
    // Fonction asynchrone pour ajouter un enregistrement à la base de données
    @MainActor
    func addUserData(id: UUID, username: String, mail: String, password: String) async -> String? {
        
        // Vérifie si l'utilisateur est déjà enregistré dans la base de données
        if await isUserAlreadyRegistered(mail: mail, json: nil)! {
            print("Utilisateur déjà inscrit")
            return nil
        }
        // Vérifie à nouveau si l'URL est valide
        guard let url = URL(string: apiURL) else {
            print("URL invalide")
            return nil
        }
        // Hash du mot de passe
        let hashPassword = hashPassword(password)
        // Prépare les données à envoyer sous forme de JSON
        let jsonData: [String: Any] = [
            "fields": [
                "ID": id.uuidString,
                "username": username,
                "mail": mail,
                "password": hashPassword
            ]
        ]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: jsonData) else {
            print("Erreur lors de la sérialisation des paramètres en JSON")
            return nil
        }
        
        // Prépare la requête HTTP POST avec les données JSON et les en-têtes nécessaires
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = postData
        
        do {
            // Envoie la requête et attend la réponse
            let (data, response) = try await URLSession.shared.data(for: request)
            // Vérifie la réponse HTTP pour confirmer l'ajout réussi
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                // Décoder les données de la réponse en JSON
                if let responseData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let newID = responseData["id"] as? String {
                        print("l'utilisateur a bien été ajouté avec l'ID: \(newID)")
                        return newID
                    } else {
                        print("Erreur lors du décodage des données de la réponse")
                        return nil
                    }
                } else {
                    print("Erreur lors du décodage des données de la réponse")
                }
                
                return nil
            } else {
                print("Erreur dans la réponse du serveur: \(response)")
                return nil
            }
        } catch {
            // Gestion des erreurs potentielles
            print("Erreur lors de l'encodage ou de l'envoi des données: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    // Fonction asynchrone pour supprimer un utilisateur dans la base
    @MainActor
    func deleteUserData(id: String) async -> Bool? {
        
        guard let url = URL(string: "\(apiURL)/\(id)") else {
            print("URL invalide")
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                print("\(id) bien supprimé")
                return true
            } else {
                print("Erreur dans la réponse du serveur: \(response)")
                return false
            }
        } catch {
            // Gestion des erreurs potentielles
            print("Erreur lors de l'encodage ou de l'envoi des données: \(error.localizedDescription)")
            return false
        }
    }

    
    @MainActor
    func checkLogging(email: String, password: String) async -> String? {
        // Hash du mot de passe fourni
        let hashPassword = hashPassword(password)
        
        // Vérifie si l'URL est valide
        guard let url = URL(string: apiURL) else {
            print("URL invalide")
            return nil
        }
        
        // Prépare la requête HTTP GET avec les en-têtes nécessaires
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        do {
            // Exécute la requête et attend la réponse
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Vérifie la réponse HTTP
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Requête échouée avec statut: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                return nil
            }
            
            // Vérifie si le JSON contient des enregistrements d'utilisateurs
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let records = json["records"] as? [[String: Any]] else {
                print("Erreur de sérialisation JSON")
                return nil
            }
            
            // Vérifie la validité de l'utilisateur avec le nom d'utilisateur et le hash du mot de passe
            let isValid = isUserValid(email: email, hashPassword: hashPassword, records: records)
            
            if isValid {
                if let userRecord = records.first(where: { ($0["fields"] as? [String: Any])?["mail"] as? String == email }) {
                    let userID = userRecord["id"] ?? "ID not found"
                    print(userID)
                    return userID as? String
                }
                print("Utilisateur trouvé avec bon mot de passe")
            } else {
                print("Utilisateur ou mot de passe non trouvé")
            }
            
            return nil
        } catch {
            // Gestion des erreurs potentielles
            print("Erreur lors de la conversion des données en JSON: \(error.localizedDescription)")
            return nil
        }
    }
    
    // Fonction pour vérifier si un utilisateur est déjà enregistré à partir de l'email
    func isUserAlreadyRegistered(mail: String, json: String?) async -> Bool? {
        var jsonString = json
        
        // Vérifie si le JSON est nil et essaie de le récupérer si c'est le cas
        if jsonString == nil {
            guard let fetchedJson = await fetchUserData() else {
                print("Impossible de récupérer la base")
                return false
            }
            jsonString = fetchedJson
            print("Données récupérées")
        }
        
        // Convertit le JSON en Data
        guard let data = jsonString?.data(using: .utf8) else {
            print("Erreur lors de la conversion de la chaîne JSON en Data")
            return false
        }
        
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let records = jsonObject["records"] as? [[String: Any]] {
                // Parcourt tous les enregistrements pour vérifier si l'email existe déjà
                for record in records {
                    if let fields = record["fields"] as? [String: Any],
                       let storedMail = fields["mail"] as? String {
                        if storedMail.trimmingCharacters(in: .whitespacesAndNewlines) == mail.trimmingCharacters(in: .whitespacesAndNewlines) {
                            print("Utilisateur déjà enregistré")
                            return true
                        }
                    }
                }
                print("Utilisateur non enregistré")
                return false
            } else {
                print("Erreur de sérialisation JSON ou structure inattendue")
                return false
            }
        } catch {
            // Gestion des erreurs potentielles
            print("Erreur lors de la conversion des données en JSON: \(error.localizedDescription)")
            return false
        }
    }
    
    // Fonction pour vérifier la validité de l'utilisateur avec le nom d'utilisateur et le hash du mot de passe
    func isUserValid(email: String, hashPassword: String, records: [[String: Any]]) -> Bool {
        // Parcourt tous les enregistrements pour trouver une correspondance
        for record in records {
            if let fields = record["fields"] as? [String: Any],
               let storedEmail = fields["mail"] as? String,
               let storedPassword = fields["password"] as? String {
                // Vérifie si le nom d'utilisateur et le mot de passe correspondent
                if storedEmail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() &&
                    storedPassword.trimmingCharacters(in: .whitespacesAndNewlines) == hashPassword.trimmingCharacters(in: .whitespacesAndNewlines) {
                    return true
                }
            }
        }
        return false
    }
    
    // Fonction de hachage du mot de passe utilisant l'algorithme SHA-256
    private func hashPassword(_ password: String) -> String {
        // Convertir le mot de passe en Data
        let data = Data(password.utf8)
        
        // Utiliser SHA-256 pour hasher le mot de passe
        let hashed = SHA256.hash(data: data)
        
        // Convertir le hash en une chaîne hexadécimale
        print("Password Hashed")
        return hashed.map { String(format: "%02hhx", $0) }.joined()
    }
}
