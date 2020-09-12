//
//  File.swift
//  
//
//  Created by Diogo Ribeiro on 29/08/2020.
//

import Foundation


public let ingredientsServiceRepository = IngredientsServiceRepository()

//MARK: MODELS

public struct Ingredient : Identifiable, Hashable, Codable {
    public var id = UUID().uuidString
    public var name: String
    public var unit: String
    public var packageQty: Int
    public var amountPaidEachProduct: Double
    public var amountUsedInTheRecipe: Double
    public var grossCost: Double
}

//MARK: SERVICE

protocol IngredientsService {
    func add(value1: String,value2: String,value3: String,value4: String, value5: String,value6: String) -> Bool
    func get(id: String) -> Ingredient?
    func update(value: Ingredient) -> Bool
    func getAll() -> [Ingredient]
}

public struct IngredientsServiceRepository: IngredientsService {
    
    private var defaults = UserDefaults.standard
    
    public init() {}
    
    public func getAll() -> [Ingredient] {
        return getList()
    }
    
    public func add(value1: String,value2: String,value3: String,value4: String, value5: String,
                    value6: String) -> Bool {
        
        let value = Ingredient(name: value1, unit: value2, packageQty: Int(value3)!, amountPaidEachProduct: Double(value4)!, amountUsedInTheRecipe: Double(value5)!, grossCost: Double(value6)! )
        
        return save(it: value)
    }
    
    public func get(id: String) -> Ingredient? {
        return getList().first { item in
            item.id == id
        }
    }
    
    public func update(value: Ingredient) -> Bool {
        
        var list = getList()
        guard let index = list.firstIndex(where: {$0.id == value.id }) else { return false }
        list[index] = value
        return setList(list)
    }
    
    private func getList() -> [Ingredient] {
        var list : [Ingredient] = []
        do {
            let it = try defaults.getObject(forKey: "Ingredients", castTo: [Ingredient].self)
            list.append(contentsOf: it)
        } catch {
            print(error.localizedDescription)
        }
        return list
    }
    
    private func save(it: Ingredient) -> Bool {
        var list = getList()
        list.append(it)
        return setList(list)
    }
    
    private func setList(_ list: [Ingredient]) -> Bool{
        do {
            try defaults.setObject(list, forKey: "Ingredients")
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
}
