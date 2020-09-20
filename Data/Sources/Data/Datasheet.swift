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
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
    }
    
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
    public var name: String = ""
    public var price: Double = 0.0
    public var produtcs: [Product] = []
}

//MARK: SERVICE

protocol DatasheetService {
    func getAll() -> [Datasheet]
    func add(value: Datasheet)
}

public class DatasheetRepository: BaseRepo<Datasheet>,DatasheetService {
    
    public func getAll() -> [Datasheet] {
        return getList()
    }
    
    public func add(value: Datasheet) {
        var list = getList()
        list.append(value)
        print("DatasheetRepository saved: \(setList(list))")
    }
    
    
}
