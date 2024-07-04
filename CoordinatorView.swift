//
//  CoordinatorView.swift
//  EatSideStory
//
//  Created by FrancoisW on 07/06/2024.
//
import SwiftUI
import MapKit

struct CoordinatorView: View {
    @State private var isActive = false
    @EnvironmentObject private var themeManager: ThemeManager
    //  @EnvironmentObject private var bluetoothManager: BluetoothManager
    @State private var selection = 0 // Set the default tab (third tab)
    @State var isLandingScreenView = true
    
    @State private var cameraPosition: MapCameraPosition = .automatic // Automatic means that it will center on markers set on the map

    @State var userProfile : UserProfile = UserProfile()

    // Properties stored in UserDefaults
     @AppStorage("userID") private var userIDString: String = UUID().uuidString
     @AppStorage("userRef") private var userRef: String = ""
     @AppStorage("userName") private var userName: String = ""
     @AppStorage("userEmail") private var userEmail: String = ""
     @AppStorage("isSignedIn") private var isSignedIn: Bool = false
     @AppStorage("isInitialized") private var isInitialized: Bool = false

    
    var body: some View {
        
        if isActive {
            if isLandingScreenView {
                LandingScreenView(userProfile : userProfile, isLandingScreenView : $isLandingScreenView, cameraPosition : $cameraPosition)
            } else {
                MapScreenView(userProfile : userProfile, isLandingScreenView : $isLandingScreenView, cameraPosition : $cameraPosition)
            }
        } else {
            SplashScreenView(isActive: $isActive)
        }
    }
}

#Preview {
    CoordinatorView()
}
