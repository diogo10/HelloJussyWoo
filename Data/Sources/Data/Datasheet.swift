import Foundation

public let datasheetRepository = DatasheetRepository()

//public extension Decodable {
//    init(from: Any) throws {
//    let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
//    let decoder = JSONDecoder()
//    self = try decoder.decode(Self.self, from: data)
//  }
//}

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
        list.append(value)
        let result = setList(list)
        print("DatasheetRepository saved: \(result)")
    }
    
    func delete(values: [Int]) {
        self.delete(index: values)
    }
    
}
