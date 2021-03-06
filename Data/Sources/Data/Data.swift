import Foundation
import Alamofire

var ip = "hellojussy.pt"
let consumerKey = "ck_468fd2df86c0cdcb645e36446578950b0d416135"
let consumerSecret = "cs_6fe5dff60892c9062f089733bfade59d676ef774"
var base = "https://\(ip)/index.php/wp-json/wc/v3/"
let query = "consumer_key=\(consumerKey)&consumer_secret=\(consumerSecret)"

let session: Session = {
    let manager = ServerTrustManager(evaluators: [ip: DisabledTrustEvaluator()])
    let configuration = URLSessionConfiguration.af.default
    return Session(configuration: configuration, serverTrustManager: manager)
}()


public let repoExpenses = ExpensesServiceRepository()


//MARK: DOMAIN

protocol WooService {
    func getOrders(status: String,result: @escaping ([OrderData]) -> Void)
    func changeIP(newIp: String)
    func changeStatus(orderId: String,newStatus: OrderStatus, result: @escaping (Bool) -> Void)
}

public struct WooRepository:WooService {
    
    //MARK: ACTIONS
    
    public func changeStatus(orderId: String,newStatus: OrderStatus,result: @escaping (Bool) -> Void) {
        let requestURL = buildChangeOrderURL(orderId: orderId)
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        let parameters = ["status": newStatus.rawValue]
        
        session.request(requestURL, method: .put, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                print(value)
                result(true)
            case .failure(let error):
                print(error)
                result(false)
            }
        }
    }
    
    
    public func changeIP(newIp: String) {
        ip = newIp
        base = "https://\(ip)/hellojussy/index.php/wp-json/wc/v3/"
    }
    
    
    public init() {}
    
    public func getOrders(status: String = OrderStatus.ONHOLD.rawValue,result: @escaping ([OrderData]) -> Void) {
        var requestURL = buildURL(methodName: "orders")
        requestURL = addStatus(url: requestURL, status: status)
        
        session.request(requestURL).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                print("SUCCESS")
                print(value)
                do {
                    let values = try JSONDecoder().decode([OrderData].self, from: response.data!)
                    result(values)
                    
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                    result([])
                }
                
                
                
            case .failure(let error):
                print("FAIL: " + error.errorDescription! )
                result([])
            }
        }
    }
    
    //MARK: UTILS
    
    private func buildURL(methodName: String) -> String {
        return base + methodName + "?" + query
    }
    
    private func buildChangeOrderURL(orderId: String) -> String {
        let methodName = "orders"
        return base + methodName + "/\(orderId)?" + query
    }
    
    private func addStatus(url: String, status: String) -> String {
        return url + "&status=" + status
    }
}

//MARK: Expenses

protocol ExpensesService {
    func getFixedExpense(result: @escaping ([FixedExpense]) -> Void)
    func addFixedExpense(value: Double, name: String)
    func updateFixedExpense(id: String, value: Double, name: String)
    func getFixedExpense(id: String) -> FixedExpense?
    func deleteFixedExpense(index: [Int])
    
    func total() -> Double
    func addTax(value: Double)
    func impactInEachProduct() -> Double
    func setCurrency(value: String)
    func getCurrency() -> String
    func getTargetSales() -> Double
    mutating func setTargetSales(value: Double)
}

public struct ExpensesServiceRepository: ExpensesService {
    
    private var defaults = UserDefaults.standard
    
    public init() {}
    
    public func addFixedExpense(value: Double, name: String) {
        var list = getFixedExpense()
        list.append(FixedExpense(name: name, total: value))
        do {
            try defaults.setObject(list, forKey: "FixedExpenseList")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func updateFixedExpense(id: String, value: Double, name: String) {
        var list = getFixedExpense()
        guard let index = list.firstIndex(where: {$0.id == id }) else { return }
        list[index].name = name
        list[index].total = value
        do {
            try defaults.setObject(list, forKey: "FixedExpenseList")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func getFixedExpense(id: String) -> FixedExpense? {
        do {
            let it = try defaults.getObject(forKey: "FixedExpenseList", castTo: [FixedExpense].self)
            return it.first { item in
                item.id == id
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    public func getFixedExpense(result: @escaping ([FixedExpense]) -> Void) {
        result(getFixedExpense())
    }
    
    private func getFixedExpense() -> [FixedExpense] {
        var list : [FixedExpense] = []
        do {
            let it = try defaults.getObject(forKey: "FixedExpenseList", castTo: [FixedExpense].self)
            list.append(contentsOf: it)
        } catch {
            print(error.localizedDescription)
        }
        
        return list
    }
    
    public func deleteFixedExpense(index: [Int]) {
        var list = getFixedExpense()
        index.forEach { item in
            list.remove(at: item)
        }
        
        do {
            try defaults.setObject(list, forKey: "FixedExpenseList")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func total() -> Double {
        return getFixedExpense().map { item in
            item.total
        }.sum()
    }
    
    public func addTax(value: Double) {
        defaults.set(value, forKey: "tax")
    }
    
    public func getTax() -> Double {
        return defaults.double(forKey: "tax")
    }
    
    public func impactInEachProduct() -> Double {
        let fixed = total()
        let target = getTargetSales()
        let total = (fixed / target) * 100
        if total.isNaN {
            return 0.0
        }
        return total.rounded()
    }
    
    public func setCurrency(value: String) {
        defaults.set(value, forKey: "currencySimbol")
    }
    
    public func getCurrency() -> String {
        return defaults.string(forKey: "currencySimbol") ?? "R$"
    }
    
    public func getTargetSales() -> Double {
        return defaults.double(forKey: "targetSales")
    }
    
    public func setTargetSales(value: Double) {
        defaults.set(value, forKey: "targetSales")
    }
    
}



//MARK: Extension

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element { reduce(.zero, +) }
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}

//MARK: MODELS

public struct FixedExpense : Identifiable, Codable {
    public var id = UUID().uuidString
    public var name: String
    public var total: Double
    public var color: String = "#EEEEEE"
}

public struct OrderData : Identifiable,Decodable{
    public var id: Int
    public var status: String
    public var customerNote: String
    public var total: String
    public var clientName: String
    public var address: String
    public var city: String
    public var postcode: String
    public var shippingTotal: String
    public var createdAt: String
    public let items: [Product]
    
    enum CodingKeys: String, CodingKey {
        //Objs
        case shipping = "shipping"
        case billing = "billing"
        case line_items = "line_items"
        
        case first_name = "first_name"
        case last_name = "last_name"
        case address_1 = "address_1"
        case address_2 = "address_2"
        case city = "city"
        case postcode = "postcode"
        
        case id = "id"
        case status = "status"
        case customer_note = "customer_note"
        case total = "total"
        case shippingTotal = "shipping_total"
        case createdAt = "date_created"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let billing = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .billing)
        clientName = try billing.decode(String.self, forKey: .first_name)
        let lastName = try billing.decode(String.self, forKey: .last_name)
        clientName = "\(clientName) \(lastName)"
        
        let shipping = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .shipping)
        let address1 = try shipping.decode(String.self, forKey: .address_1)
        let address2 = try shipping.decode(String.self, forKey: .address_2)
        address = "\(address1) \(address2)"
        city = try shipping.decode(String.self, forKey: .city)
        postcode = try shipping.decode(String.self, forKey: .postcode)
        
        
        id = try container.decode(Int.self, forKey: .id)
        status = try container.decode(String.self, forKey: .status)
        customerNote = try container.decode(String.self, forKey: .customer_note)
        total = try container.decode(String.self, forKey: .total)
        total.appedingEuro()
        shippingTotal = try container.decode(String.self, forKey: .shippingTotal)
        shippingTotal.appedingEuro()
        createdAt = try container.decode(String.self, forKey: .createdAt)
        createdAt.formatDate()
        
        items = try container.decode([Product].self, forKey: .line_items)
        
    }
    
    
    
}

public enum OrderStatus: String {
    
    case ONHOLD = "on-hold"
    case COMPLETED = "completed"
    case CANCELED = "cancelled"
    case ANY = "any"
    case PROCESSING = "processing"
    case REFUNDED = "refunded"
}

//MARK: Products

public struct Product: Codable,Identifiable {
    public var id = UUID()
    public var name: String
    public var price: Double
    public var quantity: Double = 0.0
    public var unit: String
}

protocol ProductsService {
    func getAll() -> [Product]
    func add(name: String, price: Double, unit: String) -> Bool
    func update(product: Product) -> Bool
    func get(id: String) -> Product?
}


public let productsRepository = ProductsRepository()

public class ProductsRepository: BaseRepo<Product>, ProductsService  {
    
    override init() {
        super.init()
        self.table = "Products"
    }
    
    public func getAll() -> [Product] {
        return getList()
    }
    
    public func add(name: String, price: Double, unit: String) -> Bool {
        var list = getList()
        list.append(Product(name: name, price: price, unit: unit))
        return setList(list)
    }
    
    public func update(product: Product) -> Bool {
        var list = getList()
        guard let index = list.firstIndex(where: { $0.id == product.id }) else { return false }
        list[index].name = product.name
        list[index].price = product.price
        list[index].unit = product.unit
        return setList(list)
    }
    
    public func get(id: String) -> Product? {
        return getList().first { item in
            item.id.uuidString == id
        }
    }
    
    public func emptyProduct() -> Product {
        return Product(name: "Add one product", price: 0, unit: "")
    }
}


public class BaseRepo<T: Codable> {
    
    private var defaults = UserDefaults.standard
    var table = ""
    
    
    public init() {}
    
    func setList(_ list: [T]) -> Bool {
        do {
            try defaults.setObject(list, forKey: table)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getList() -> [T] {
        var list : [T] = []
        do {
            let it = try defaults.getObject(forKey: table, castTo: [T].self)
            list.append(contentsOf: it)
        } catch {
            print(error.localizedDescription)
        }
        return list
    }
    
    public func delete(index: [Int]) {
           var list = getList()
           index.forEach { item in
               list.remove(at: item)
           }
           
           do {
               try defaults.setObject(list, forKey: table)
           } catch {
               print(error.localizedDescription)
           }
       }
    
    
    
}
