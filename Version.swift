//  Version.swift
//  AINAO Nav
//
//  Created by FrancoisW on 25/06/2024.

import Foundation
struct VersionInfo {
    let version: String
    let description: String
}

struct VersionHistory {
    static let current =
    VersionInfo(version: "1.0.1", description: "2024 July 4th Release Candidate")

    static let history: [VersionInfo] = [
        VersionInfo(version: "0.0.1", description: "2024 June 7th, Creation "),
        VersionInfo(version: "0.0.2", description: "2024 June 16th, Integration of Map and markers, creation of UserProfile and Placemark"),
        VersionInfo(version: "0.0.3", description: "2024 Re created branch after fatal error"),
        VersionInfo(version: "0.0.4", description: "2024 First version put in Git"),
        VersionInfo(version: "0.0.7", description: "2024 19th : Many modifications, new repository created"),
        VersionInfo(version: "0.0.8", description: "2024 June 25th : Integration of views from (ProfileScreen and Settings Screens) from vincents and file udates from Augustin"),
        VersionInfo(version: "0.1.0", description: "2024 June 25th : Since we give up for the momment gitHub, we upgrade version number"),
        VersionInfo(version: "0.1.1", description: "2024 June 26th : Integration of POXMapItemInfoView(), Introduction of POTEditView"),
        VersionInfo(version: "0.2.0", description: "2024 June 26th : MAJOR re-structuring of landingView and mapView (ModelContext removed)"),
        VersionInfo(version: "0.2.1", description: "2024 June 26th :Integration of Views from Allan (POTForm, POTEdit)"),
        VersionInfo(version: "0.3.0", description: "2024 June 28th : Removal of the TabItem in Coordinator View, Introduction of ProfileScreen in LandingScreen"),
        VersionInfo(version: "0.3.1", description: "2024 June 30th : Integration of numerous modification in MapView, MapScreen View and Lading screen view. Persistent storage"),
        VersionInfo(version: "0.4.0", description: "2024 June 1st : Few changes, creation of the UserData protocol extensions"),
        VersionInfo(version: "0.6.0", description: "2024 June 1st : Full Async Version!!! + beginning of creation of POITsand POIs from Map"),
        VersionInfo(version: "0.7.0", description: "2024 June 3rd : Integration of the new splash screen(video+logo)"),
        VersionInfo(version: "0.8.0", description: ""),
        VersionInfo(version: "0.9.0", description: "2024 June 3rd : Integration de landing screen"),
        VersionInfo(version: "0.10.0", description: "2024 June 3rd : Integration extension augustin+New Landing Screen")

   ]
    
    static func getVersionDescription(for version: String) -> String? {
        return history.first(where: { $0.version == version })?.description
    }
}
