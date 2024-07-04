//
//  POIDataAPI.swift
//  AINAO_Nav
//
//  Created by Apprenant 101 on 27/06/2024.
//

import Foundation

class POIDataAPI: ObservableObject {
    
    @Published var poiModel: POIResponse? = nil
    private let apiKey = Consts.Services.airtableMainDBKey
    private let apiURL = Consts.Services.airtablePOIDBImportRequest
    
    @MainActor
    func fetchPOIData() async -> String? {
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
    func addPOIModel() async -> POIResponse? {
        
        guard let url = URL(string: apiURL) else {
            print("URL invalide")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(data: data, encoding: .utf8)!)

            let decodedData = try JSONDecoder().decode(POIResponse.self, from: data)
            self.poiModel = decodedData
            print("Données bien ajoutées à la liste")
            return decodedData
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
                print(error.localizedDescription)
                print(error)
            }
            return nil
        }
    }
    
    
    @MainActor
    func addPOIData(name: String, type: String, longitude: Double, latitude: Double, address: String, picture: String?, description: String?, userDataID: String)  async -> String? {
        
        guard let url = URL(string: apiURL) else {
            print("URL Invalide")
            return nil
        }
        
        let jsonData: [String: Any] = [
            "fields": [
                "name": name,
                "type": [type],
                "longtitude": longitude,
                "latitude": latitude,
                "address": address,
                "picture": [picture],
                "description": description ?? "",
                "UserData Log": [userDataID]
            ]
        ]
        guard let postData = try?
                JSONSerialization.data(withJSONObject: jsonData) else {
            print("Erreur de sérialisation")
            return nil
        }
        

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
                        print("L'ID du POI est: \(newID)")
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
                print("\n\nErreur dans la réponse du serveur: \(response)")
                return nil
            }
        } catch {
            // Gestion des erreurs potentielles
            print("Erreur lors de l'encodage ou de l'envoi des données: \(error.localizedDescription)")
            return nil
        }
    }
    
    @MainActor
    func deletePOIData(id: String) async -> Bool? {
        guard let url = URL(string: "\(apiURL)/\(id)") else {
            print("URL invalide")
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        do {
            // Envoie la requête et attend la réponse
            let (_, response) = try await URLSession.shared.data(for: request)
            // Vérifie la réponse HTTP pour confirmer la suppression réussie
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                print("Suppression réussie")
                return true
            } else {
                print("Erreur dans la réponse du serveur: \(response)")
                return false
            }
        } catch {
            // Gestion des erreurs potentielles
            print("Erreur lors de l'envoi de la requête de suppression: \(error.localizedDescription)")
            return false
        }
    }
    
    
    
}
