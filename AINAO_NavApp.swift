//
//  AINAO_NavApp.swift
//  AINAO Nav
//
//  Created by FrancoisW on 20/06/2024.
//

import SwiftUI
import SwiftData

@main
struct AINAO_NavApp: App {

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            AppData.self, // App data is the only container of the project. Everythin lse is stored in the cloud
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        print("Attempting to create the container...")

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            print("container sucessfully created")
            return container
        } catch {
            print("Error creating ModelContainer: \(error)")
            // Handle the error
            fatalError("Could not create ModelContainer: \(error)")

        }
        /*
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
         */
    }()

    var body: some Scene {
        WindowGroup {
            CoordinatorView()
        }
        .modelContainer(sharedModelContainer)
    }
}
