//
//  Location.swift
//  EatSideStory
//
//  Created by FrancoisW on 20/06/2024.
//

import CoreLocation
import Combine
/**
    IMPORTANT CoreLocation :
 
 To set up full access to location services in your Xcode project, you’ll need to configure the Info.plist file with the appropriate keys. Here are the steps and keys you should include:

 NSLocationWhenInUseUsageDescription: This key is required if your app uses location services while running in the foreground. You must provide a message explaining why your app needs this permission, which will be displayed in the permission prompt to the user.
 NSLocationAlwaysUsageDescription: Use this key if your app needs location information at all times, even when running in the background.
 NSLocationAlwaysAndWhenInUseUsageDescription: If your app supports iOS 11 and later, and it needs location services both when the app is in use and when it’s in the background, you should use this key.
 
 To modify the Info.plist via the IDE, 
 * go to the project left side bar
 * Select your target
 * On the tab menu, select Info
 * Add the three above keyx by selecting a + button in tje key column, you can add a key above any of the keys already define, that doesn't matter
  * When entering the new key type the names above ("NSLOcation..", then enter the description of your choice in the value field (which shall be strung type)
 
 */
class LocationManagerDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
        }
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            //print("Location Authorization: Granted.")
            break
        case .denied:
            print("Location Authorization: Denied.")
        case .restricted:
            print("Location Authorization: Restricted.")
        case .notDetermined:
            print("Location Authorization: Not Determined. Requesting authorization again.")
            manager.requestWhenInUseAuthorization()
        @unknown default:
            print("Location Authorization: Unknown.")
        }
    }
}
