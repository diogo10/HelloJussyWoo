//
//  File.swift
//  
//
//  Created by Diogo Ribeiro on 20/09/2020.
//

import Foundation


public let moneyEntryRepository = MoneyEntryRepository()

//MARK: MODELS


extension MoneyEntry {
    public init(from: Any) throws {
        let data = from as! Dictionary<String, Any>
        id = data["id"] as? UUID ?? UUID()
        name = data["name"] as? String ?? ""
        total = data["total"] as? Double ?? 0.0
        date = data["date"] as? Date ?? Date()
        type = data["type"] as? Int ?? 0
        color = data["color"] as? String ?? ""
    }
}

public struct MoneyEntry : Identifiable, Codable {
    public var id = UUID()
    public var name: String
    public var type: Int = 0
    public var total: Double
    public var color: String = "#EEEEEE"
    public var date: Date
}

//MARK: SERVICE

protocol MoneyEntryService {
    func getAll() -> [MoneyEntry]
    func add(value: MoneyEntry)
}

public class MoneyEntryRepository: BaseRepo<MoneyEntry> ,MoneyEntryService {
    
    public func getAll() -> [MoneyEntry] {
        return getList()
    }
    
    public func add(value: MoneyEntry) {
        var list = getList()
        
        if let index = list.firstIndex(where: {$0.id.uuidString == value.id.uuidString }) {
            list[index] = value
            print("MoneyEntryServiceRepository update")
        }else {
            list.append(value)
            print("MoneyEntryServiceRepository add")
        }
        
        let result = setList(list)
        print("MoneyEntryServiceRepository result> \(result)")
    }
    
    func delete(values: [Int]) {
        self.delete(index: values)
    }
    
    
}
