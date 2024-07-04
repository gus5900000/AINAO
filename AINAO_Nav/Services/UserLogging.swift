//
//  UserLogging.swift
//  EatSideStory
//
//  Created by Apprenant 101 on 19/06/2024.
//

import Foundation
import CryptoKit

/*
 class UserData: ObservableObject {
 
 @Published var userProfilModel: UserProfilResponse? = nil
 private let apiKey = Consts.Services.airtableMainDBKey
 private let apiURL = Consts.Services.airtableMainDBImportRequest
 
 // Fonction asynchrone pour récupérer le JSON complet depuis l'API
 @MainActor
 func getRecordAirTable() async -> String? {
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
 func addUserModel(id: String) async {
 //Permet de check si l'URL fonctionne et si oui le met dans l'objet URL
 guard let url = URL(string: "\(apiURL)/\(id)") else {
 print("URL invalide")
 return
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
 }
 
 
 
 
 // Fonction asynchrone pour ajouter un enregistrement à la base de données
 @MainActor
 func addRecordAirTable(id: UUID, username: String, mail: String, password: String) async -> Bool {
 // Récupère le JSON complet de la base de données
 guard (await getRecordAirTable()) != nil else {
 print("Impossible de récuperer la base")
 return false
 }
 // Vérifie si l'utilisateur est déjà enregistré dans la base de données
 if await isUserAlreadyRegistered(mail: mail, json: nil) {
 print("Utilisateur déjà inscrit")
 return false
 }
 // Vérifie à nouveau si l'URL est valide
 guard let url = URL(string: apiURL) else {
 print("URL invalide")
 return false
 }
 // Hash du mot de passe
 let hashPassword =  hashPassword(password)
 // Prépare les données à envoyer sous forme de JSON
 let jsonData: [String: Any] = [
 "fields": [
 "ID": id,
 "username": username,
 "mail": mail,
 "password": hashPassword
 ]
 ]
 
 // Prépare la requête HTTP POST avec les données JSON et les en-têtes nécessaires
 var request = URLRequest(url: url)
 request.httpMethod = "POST"
 request.setValue("application/json", forHTTPHeaderField: "Content-Type")
 request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
 
 do {
 // Encodage des données JSON dans le corps de la requête
 request.httpBody = try JSONSerialization.data(withJSONObject: jsonData);
 print("Donnée bien encodée")
 
 // Envoie la requête et attend la réponse
 let (_, response) = try await URLSession.shared.data(for: request)
 // Vérifie la réponse HTTP pour confirmer l'ajout réussi
 if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
 print("\(username) bien ajouté")
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
 
 // Fonction asynchrone pour vérifier l'authentification d'un utilisateur
 @MainActor
 func checkLogging(username: String, password: String) async -> Bool {
 // Hash du mot de passe fourni
 let hashPassword = hashPassword(password)
 // Vérifie à nouveau si l'URL est valide
 guard let url = URL(string: apiURL) else {
 print("URL invalide")
 return false
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
 return false
 }
 // Vérifie si le JSON contient des enregistrements d'utilisateurs
 if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
 let records = json["records"] as? [[String: Any]] {
 // Vérifie la validité de l'utilisateur avec le nom d'utilisateur et le hash du mot de passe
 let isValid = isUserValid(username: username, hashPassword: hashPassword, records: records)
 if isValid {
 print("Utilisateur trouvé avec bon mot de passe")
 } else {
 print("Utilisateur ou mot de passe non trouvé")
 }
 return isValid
 } else {
 print("Erreur de sérialisation JSON")
 return false
 }
 } catch {
 // Gestion des erreurs potentielles
 print("Erreur lors de la conversion des données en JSON: \(error.localizedDescription)")
 return false
 }
 }
 
 // Fonction asynchrone pour supprimer un utilisateur dans la base
 @MainActor
 func deleteRecordAirTable(id: String) async -> Bool {
 
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
 func updateRecordAirTable(id: String, json: String?) async -> Bool {
 
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
 
 // Fonction pour vérifier si un utilisateur est déjà enregistré à partir de l'email
 private func isUserAlreadyRegistered(mail: String, json: String?) async -> Bool {
 var jsonString = json
 
 // Vérifie si le JSON est nil et essaie de le récupérer si c'est le cas
 if jsonString == nil {
 guard let fetchedJson = await getRecordAirTable() else {
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
 return true
 }
 }
 }
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
 private func isUserValid(username: String, hashPassword: String, records: [[String: Any]]) -> Bool {
 // Parcourt tous les enregistrements pour trouver une correspondance
 for record in records {
 if let fields = record["fields"] as? [String: Any],
 let storedUsername = fields["username"] as? String,
 let storedPassword = fields["password"] as? String {
 // Vérifie si le nom d'utilisateur et le mot de passe correspondent
 if storedUsername.trimmingCharacters(in: .whitespacesAndNewlines) == username.trimmingCharacters(in: .whitespacesAndNewlines) &&
 storedPassword.trimmingCharacters(in: .whitespacesAndNewlines) == hashPassword.trimmingCharacters(in: .whitespacesAndNewlines) {
 return true
 }
 }
 }
 return false
 }
 }
 */
