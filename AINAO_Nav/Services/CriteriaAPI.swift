//
//  CriteriaAPI.swift
//  AINAO_Nav
//
//  Created by Apprenant 101 on 26/06/2024.
//

import Foundation

class CriteriaData: ObservableObject {
    
    @Published var criteriaModel: CriteriaResponse? = nil
    private let apiKey = Consts.Services.airtableMainDBKey
    private let apiURL = Consts.Services.airtableCriteriaDBImportRequest
    
    
    
    @MainActor
    func fetchCriteriaData() async -> String? {
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
    func addUserModel(id: String) async  -> CriteriaResponse? {
        //Permet de check si l'URL fonctionne et si oui le met dans l'objet URL
        guard let url = URL(string: "\(apiURL)/\(id)") else {
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
            print(String(data: data, encoding: .utf8)!)

            // Décodage ou conversion des données reçues au format UserProfileModel
            let decodedData = try JSONDecoder().decode(CriteriaResponse.self, from: data)

            self.criteriaModel = decodedData
            print("Données bien ajoutées à la liste")
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
        }
        return nil
    }
    
    
    
    
    
    // Fonction asynchrone pour supprimer un utilisateur dans la base
    @MainActor
    func deleteCriteriaData(id: String) async -> Bool? {
        
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
    func updateCriteriaData(id: String, json: String?) async -> Bool {
        
        guard let url = URL(string: "\(apiURL)/\(id)") else {
            print("URL invalide")
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = json?.data(using: .utf8)
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                print("\(id) bien mis à jour")
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
    
}
