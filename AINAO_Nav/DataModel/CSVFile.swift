//
//  CSVFile.swift
//  EatSideStory
//
//  Created by FrancoisW on 07/06/2024.
//

import Foundation


struct KeyValueWrapper: Identifiable {
    let id = UUID()
    public let key: String
    public let value: String
}

let K1 = KeyValueWrapper(key: "Toto", value: "Toto")
let K2 = KeyValueWrapper(key: "Toto", value: "Toto")


/*
 func parseCSV(contentsOfFile: String) -> [[String: String]] {
 var result: [[String: String]] = []
 
 let rows = contentsOfFile.components(separatedBy: Consts.CSV.EOL)
 guard let headerRow = rows.first else { return result }
 let headers = headerRow.components(separatedBy: Consts.CSV.separator)
 
 let _ = print(headers)
 
 for row in rows.dropFirst() {
 let columns = row.components(separatedBy: Consts.CSV.separator)
 let _ = print(columns)
 if columns.count == headers.count {
 var dict: [String: String] = [:]
 for (index, header) in headers.enumerated() {
 dict[header] = columns[index]
 }
 result.append(dict)
 }
 else {
 let _ = print("Probably end of file, we abort reading = \(columns.count), headers = \(headers.count)")
 }
 }
 
 return result
 }
 */

class CSVDataModel: ObservableObject {
    @Published var csvData: [KeyValueWrapper] = []
    @Published var dataLoaded = false
    
    init() {
        loadCSV()
        dataLoaded = true
    }
    
    
    func readCSV(from file: String) -> String? {
        if let filepath = Bundle.main.path(forResource: file, ofType: "csv") {
            do {
                let contents = try String(contentsOfFile: filepath, encoding: .utf8)
                return contents
            } catch {
                print("File Read Error for file \(filepath)")
                return nil
            }
        } else {
            print("File not found")
            return nil
        }
    }
    
    func parseCSV(contentsOfFile: String, maxRows: Int) -> [KeyValueWrapper] {
        var resultTmp: [[String: String]] = []
        let result: [KeyValueWrapper] = []
        
        let rows = contentsOfFile.components(separatedBy: Consts.CSV.EOL)
        guard let headerRow = rows.first else { return result }
        let headers = headerRow.components(separatedBy: Consts.CSV.separator)
        
        let _ = print("Headers : \(headers)")
        var rowCount = 0
        
        for row in rows.dropFirst().prefix(maxRows) {
            let columns = row.components(separatedBy: Consts.CSV.separator)
            let _ = print("Column(\(rowCount)) : \(columns)")
            rowCount+=1
            if columns.count == headers.count {
                var dict: [String: String] = [:]
                for (index, header) in headers.enumerated() {
                    dict[header] = columns[index]
                }
                resultTmp.append(dict)
                let _ = print("dict : (\(dict))")
            }
            else {
                let _ = print("Probably end of file, we abort reading = \(columns.count), headers = \(headers.count)")
            }
        }
        
        return result
        
    }
    
    func loadCSV() {
        print("loadCSV() called")
        
        if let contents = readCSV(from: Consts.CSV.fileName) {
            csvData = parseCSV(contentsOfFile: contents, maxRows: 2).map { row in
                KeyValueWrapper(key: row.key, value: row.value)
            }
            
            print("csvData count = \(csvData.count)")
        } else {
            print("Error when reading CSV file")
        }
    }
    
    
}


/*
 *** Doesn't work, iterates each item no each line
 
 
 func parseCSV(contentsOfFile: String) -> [KeyValueWrapper] {
 var result: [KeyValueWrapper] = []
 
 let rows = contentsOfFile.components(separatedBy: Consts.CSV.EOL)
 guard let headerRow = rows.first else { return result }
 let headers = headerRow.components(separatedBy: Consts.CSV.separator)
 
 for row in rows.dropFirst() {
 let columns = row.components(separatedBy: Consts.CSV.separator)
 if columns.count == headers.count {
 let keyValuePairs = zip(headers, columns).map { KeyValueWrapper(key: $0, value: $1) }
 result.append(contentsOf: keyValuePairs)
 } else {
 print("Probably end of file, we abort reading = \(columns.count), headers = \(headers.count)")
 }
 }
 
 return result
 }
 
 
 
 
 */

// Now assign the intermediate result to the final result
/*
 result = resultTmp.map { row in
 KeyValueWrapper(key: row.key, value: row.value)
 */
/*
 // Copying resultTmp into result
 result = resultTmp.flatMap { dict in
 dict.map { KeyValueWrapper(key: $0.key, value: $0.value) }
 }
 
 */ // THis one works well
