//
//  File.swift
//  
//
//  Created by Diogo Ribeiro on 02/10/2020.
//

import Foundation


//MARK: MODELS

public struct Category : Identifiable, Codable {
    public var id = UUID()
    public var name: String
}

//MARK: SERVICE

protocol CategoryService {
    func getAll() -> [Category]
    func add(value: Category)
    func delete(values: [Int])
}


public class CategoryRepository: BaseRepo<Category>,CategoryService {
    
    func getAll() -> [Category] {
        return getList()
    }
    
    public func add(value: Category) {
        var list = getList()
        
        if let index = list.firstIndex(where: {$0.id.uuidString == value.id.uuidString }) {
            list[index] = value
            print("CategoryRepository update")
        }else {
            list.append(value)
            print("CategoryRepository add")
        }
        
        let result = setList(list)
        print("CategoryRepository result> \(result)")
    }
    
    func delete(values: [Int]) {
        self.delete(index: values)
    }
    
    
   
}
