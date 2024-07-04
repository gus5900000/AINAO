//
//  POTDataAPI.swift
//  AINAO_Nav
//
//  Created by Apprenant 101 on 27/06/2024.
//

import Foundation

class POTDataAPI: ObservableObject {
    
    private let apiKey = Consts.Services.airtableMainDBKey
    private let apiURL = Consts.Services.airtablePOTDBImportRequest
    
    @MainActor
    func fetchPOTData() async -> String? {
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
    func addPOTData(name: String, tag: [String], longtitude: Double, latitude: Double, address: String, image: [String]?, description: String?, userDataID: [String]) async -> String? {
        
        guard let url = URL(string: apiURL) else {
            print("URL Invalide")
            return nil
        }
        
        //Faire duration en string (ISO 8601 formatted date)
        let duration = getDuration()
        
        let description2 = "Jambon"
        
        let jsonData: [String: Any] = [
            "fields": [
                "name": name,
                "tag": tag,
                "longtitude": longtitude,
                "latitude": latitude,
                "address": address,
//                "image": image,
                "description": description2,
//                "duration": duration,
                "UserData Log": userDataID
            ]
        ]
        guard let postData = try?
                JSONSerialization.data(withJSONObject: jsonData) else {
            print("Erreur de sérialisation")
            return nil
        }
        
        print("\(jsonData)")

        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
    
    func deletePOTData(id: String) async -> Bool? {
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
    
    
    
    private func getDuration() -> String {
        let date = Date()
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: date)
    }
    
}
