import Foundation

public let datasheetRepository = DatasheetRepository()

//MARK: MODELS


extension Datasheet {
    public init(from: Any) throws {
        let data = from as! Dictionary<String, Any>
        id = data["id"] as? UUID ?? UUID()
        name = data["name"] as? String ?? ""
        price = data["price"] as? Double ?? 0.0
        produtcs = data["products"] as? [Product] ?? []
    }
}

public struct Datasheet : Identifiable, Codable {
    public var id = UUID()
    public var name: String
    public var price: Double
    public var produtcs: [Product] =  []
}

//MARK: SERVICE

protocol DatasheetService {
    func getAll() -> [Datasheet]
    func add(value: Datasheet)
    func delete(values: [Int])
}

public class DatasheetRepository: BaseRepo<Datasheet>,DatasheetService {
    
    public func getAll() -> [Datasheet] {
        return getList()
    }
    
    public func add(value: Datasheet) {
        var list = getList()
        
        if let index = list.firstIndex(where: {$0.id.uuidString == value.id.uuidString }) {
            list[index] = value
            print("DatasheetRepository update")
        }else {
            list.append(value)
            print("DatasheetRepository add")
        }
        
        let result = setList(list)
        print("DatasheetRepository result> \(result)")
    }
    
    func delete(values: [Int]) {
        self.delete(index: values)
    }
    
}
