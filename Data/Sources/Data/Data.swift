import Foundation
import Alamofire

var ip = "192.168.64.2"
let consumerKey = "ck_468fd2df86c0cdcb645e36446578950b0d416135"
let consumerSecret = "cs_6fe5dff60892c9062f089733bfade59d676ef774"
var base = "https://\(ip)/hellojussy/index.php/wp-json/wc/v3/"
let query = "consumer_key=\(consumerKey)&consumer_secret=\(consumerSecret)"

private let session: Session = {
    let manager = ServerTrustManager(evaluators: [ip: DisabledTrustEvaluator()])
    let configuration = URLSessionConfiguration.af.default
    return Session(configuration: configuration, serverTrustManager: manager)
}()

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

//MARK: MODELS

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


public struct Product: Codable {
    let name: String
    let price: Double
    let quantity: Int
}

public enum OrderStatus: String {
    
    case ONHOLD = "on-hold"
    case COMPLETED = "completed"
    case CANCELED = "cancelled"
    case ANY = "any"
    case PROCESSING = "processing"
    case REFUNDED = "refunded"
}
