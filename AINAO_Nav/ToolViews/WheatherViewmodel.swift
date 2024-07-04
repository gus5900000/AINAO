//
//  WheatherViewmodel.swift
//  AINAO_Nav
//
//  Created by  Ixart on 01/07/2024.
//

import Foundation

struct WeatherResponse: Codable {
    let weather: [Weather]
    let main: Main
    
}

struct Weather: Codable, Identifiable {
    let id = UUID() // Ajout de l'identifiant
    let description: String
    
}

struct Main: Codable {
    let temp: Double
    let pressure : Int
}


@Observable


class WheatherViewmodel{
    
    var weather = [WeatherViewItem]()
    
    var isloading = false
    
//    let apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=Paris&appid=3dfe813699403684b4ca7e507c7aa26c&units=metric"
    
    let apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=Lille&appid=3dfe813699403684b4ca7e507c7aa26c&units=metric&lang=fr"

    
    
//    let apiUrl1 = "https://api.openweathermap.org/data/2.5/weather?q="
    
    
//    let apiUrl2 = "Paris"
    
//    let apiUrl3 = "&appid=3dfe813699403684b4ca7e507c7aa26c&units=metric"
   
   
//    let apiUrl = apiUrl1 + apiUrl2 + apiUrl3

    
    
    let apitoken = "3dfe813699403684b4ca7e507c7aa26c"
    
    
    @MainActor
    func fetchWeatherMeteo() async {
        
        //objet url pour la requete
        let url = URL(string: apiUrl)!
        let _ = print("111111")

        // Objet requête contenant des en-têtes ou d'autres métadonnées
        var request = URLRequest (url: url)
        request.setValue ("Bearer \(apitoken)", forHTTPHeaderField:
        "Authorization")
        let _ = print("222222")

        
        
        
        
        do{
            //Tenter d 'apeler le service api
            let (data, response) = try await URLSession.shared.data(for: request)
            let _ = print(data)

            //convertir les données
            let decodedData = try  JSONDecoder().decode(WeatherResponse.self, from: data)
            let _ = print("4444444")

            // Mettre à jour la variable
            self.weather = decodedData.weather.map { WeatherViewItem(description: $0.description, temperature: decodedData.main.temp, pressures: decodedData.main.pressure) }

            self.isloading = false
            
            
        }catch{
            self.isloading = false
            print(error.localizedDescription)
        }
        
    } // func fetch
    struct WeatherViewItem: Identifiable {
            let id = UUID() // Ajout de l'identifiant
            let description: String
            let temperature: Double
            let pressures : Int
        }
} // fin classview model


