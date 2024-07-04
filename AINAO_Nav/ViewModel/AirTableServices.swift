//
//  AirTableServices.swift
//  AINAO Nav
//
//  Created by FrancoisW on 24/06/2024.
//

import Foundation
import SwiftUI


import Foundation

// Represents a single line in the table as a dictionary.
struct Line {
    var id : UUID
    var lineId: String
    var fields: [String: Any] // Dictionary representing the fields of the line.
}

// Represents a table with lines.
struct Table {
    var id: UUID
    var parentBaseId : UUID
    var tableId: String
    var name: String
    var lines: [Line] // Array of Line structs representing each line in the database.
}

// Represents a base containing multiple tables.
struct Base {
    var id: UUID
    var baseId: String
    var name: String
    var tables: [Table] // Array of Table structs.
}

class AirTableServices {
    var token: String
    private let databaseRootURL: String
    private let basesListURL: String
    private var bases: [Base]

    init(token: String) {
        self.token = token
        self.databaseRootURL = "https://api.airtable.com/v0"
        self.basesListURL = "\(databaseRootURL)/meta/bases" // Concatenating baseURL with the endpoint.
        self.bases = [] // Initialize the bases array.
    }
 
    // Method to get the baseId by the base's name.
    func getBaseIdByName(_ name: String) -> UUID? {
        return bases.first(where: { $0.name == name })?.id
    }
    
    // Method to get the tableId by the base's ID and table's name.
    func getTableIdByBaseIdAndName(baseId: UUID, tableName: String) -> String? {
        // Find the base with the given baseId.
        guard let base = bases.first(where: { $0.id == baseId }) else {
            return nil // Base not found.
        }
        // Find the table with the given name within the found base.
        return base.tables.first(where: { $0.name == tableName })?.tableId
    }
    
    // Method to get a line from a table by the base's UUID and table's UUID.
    func getLineFromTable(baseId: UUID, tableId: UUID, lineIndex: Int) -> Line? {
        // Find the base with the given UUID.
        guard let base = bases.first(where: { $0.id == baseId }) else {
            return nil // Base not found.
        }
        // Find the table with the given UUID within the found base.
        guard let table = base.tables.first(where: { $0.id == tableId }) else {
            return nil // Table not found.
        }
        // Check if the lineIndex is within the range of available lines.
        guard lineIndex >= 0 && lineIndex < table.lines.count else {
            return nil // Line index out of range.
        }
        // Return the line at the specified index.
        return table.lines[lineIndex]
    }

}
