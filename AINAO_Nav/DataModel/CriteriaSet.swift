//
//  CriteriaSet.swift
//  AINAO Nav
//
//  Created by FrancoisW on 23/06/2024.
//


import Foundation
import SwiftData

struct Criterion {
    let type : POTType
    var isSet : Bool
}

// Define a custom error type for criteria table validation
enum CriteriaSetError: Error {
    case inconsistentTable
    case incorrectOrder
}


class CriteriaSet {
    private var criteria: Set<POTType>
    private var criteriaTable : [Criterion] // criteria and criteriaTable are the same objects, just exposed in a different way/sementic
    
    private var lastUpdate: Date

    init(criteria: Set<POTType>? = nil) {
        self.criteria = criteria ?? Set<POTType>()
        self.lastUpdate = Date()
        // Initialize the criteriaTable with all POTType cases, setting isSet to false
        self.criteriaTable = POTType.allCases.map { Criterion(type: $0, isSet: false) }
    }
    
    // Read-only computed property to access the current set of criteria
    private var currentCriteria: Set<POTType> {
       return criteria
    }
    // Method to synchronize the criteria set with the criteriaTable
     private func syncAndUpdate() {
         criteria = Set(criteriaTable.filter { $0.isSet }.map { $0.type })
         lastUpdate = Date()
     }

    // Method to accept the modified copy of the criteriaTable
       func updateCriteria(with modifiedTable: [Criterion]) throws {
           // Validate the modified table
           guard modifiedTable.count == criteriaTable.count else {
               throw CriteriaSetError.inconsistentTable
           }

           // Check if all POTTypes are present and in the correct order
           for (index, criterion) in modifiedTable.enumerated() {
               guard criterion.type == criteriaTable[index].type else {
                   throw CriteriaSetError.incorrectOrder
               }
           }

           // Update the internal criteriaTable and criteria set
           criteriaTable = modifiedTable
           syncAndUpdate()
       }

    // Method to return criteria as an array
    var criteriaArray: [Criterion] {
        return criteriaTable
    }
    
    /*
    func addCriterion(_ criterion: POTType) {
        criteria.insert(criterion)
        lastUpdate = Date()
    }
    
    // Please note that unlike landmarks management, we don't check if a criterion was present or not
    func removeCriterion(_ criterion: POTType) {
        criteria.remove(criterion)
        lastUpdate = Date()
    }
    
    func containsCriterion(_ criterion: POTType) -> Bool {
        return criteria.contains(criterion)
    }
    
    // Removes all criteria from the set
    func resetCriteria() {
        criteria.removeAll()
        lastUpdate = Date()
    }
     */
}

