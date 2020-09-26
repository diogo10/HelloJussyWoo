import Foundation
import Alamofire

//MARK: MODELS

extension MoneyEntry {
    public init(from: Any) throws {
        let data = from as! Dictionary<String, Any>
        seq = UUID()
        id = mapStringValue(data["id"] as? NSDictionary)
        name = mapStringValue(data["name"] as? NSDictionary)
        total = mapDoubleValue(data["total"] as? NSDictionary)
        date = data["date"] as? Date ?? Date()
        type = mapIntegerValue(data["type"] as? NSDictionary)
        client =  mapStringValue(data["client"] as? NSDictionary)
        location =  mapStringValue(data["location"] as? NSDictionary)
        extras =  mapStringValue(data["extras"] as? NSDictionary)
        month = mapIntegerValue(data["month"] as? NSDictionary)
        year = mapIntegerValue(data["year"] as? NSDictionary)
    }
    
    private func mapStringValue(_ data: NSDictionary?) -> String {
        return data?["stringValue"] as? String ?? ""
    }
    
    private func mapIntegerValue(_ data: NSDictionary?) -> Int {
        let value = data?["integerValue"] as? String ?? "0"
        return Int(value) ?? 0
    }
    
    private func mapDoubleValue(_ data: NSDictionary?) -> Double {
        return data?["doubleValue"] as? Double ?? 0.0
    }
}

public struct MoneyEntry : Identifiable, Codable {
    public var seq = UUID()
    public var id: String = ""
    public var name: String = ""
    public var type: Int = 1
    public var total: Double = 0.0
    public var date: Date = Date()
    public var client: String = ""
    public var location: String = ""
    public var extras: String = ""
    public var month: Int = 1
    public var year: Int = 1
}

//MARK: SERVICE

protocol MoneyEntryService {
    func getAll(result: @escaping ([MoneyEntry]) -> Void)
    func add(value: MoneyEntry)
}

public class MoneyEntryRepository: MoneyEntryService {
    
    let baseGoogleCloudUrl = "https://identitytoolkit.googleapis.com/"
    let baseGoogleFirestoreUrl = "https://firestore.googleapis.com/"
    let serverGoogleCloudKey = "AIzaSyCOXsIcGPD75cf41G5R-UE7A2YgZYEtI5E"
    let signInMethod = "v1/accounts:signInWithPassword"
    let getFinanceMethod = "v1/projects/diogoprojects-617e2/databases/(default)/documents/helloJussyFinance"
    
    private var list: [MoneyEntry] = []
    
    public func add(value: MoneyEntry) {
        
    }
    
    public func getAll(result: @escaping ([MoneyEntry]) -> Void) {
        let requestURL = "\(baseGoogleFirestoreUrl)\(getFinanceMethod)?key=\(serverGoogleCloudKey)"
        let authtoken = token ?? ""
        print("authtoken is empty: \(authtoken.isEmpty)")
        
        if authtoken.isEmpty {
            result([])
        }
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(authtoken)"
        ]
        
        print("requesting sales")
        sessionAuth.request(requestURL, headers: headers).validate().responseJSON { response in
            self.list.removeAll()
            
            switch response.result {
            case .success(let value):
                if let jsonResult = value as? NSDictionary {
                    self.list.append(contentsOf: self.manageResponse(dic: jsonResult))
                }else  {
                    self.list.removeAll()
                }
                
                result(self.list)
                
            case .failure(let error):
                debugPrint("Error: \(error)")
                self.list.removeAll()
                debugPrint(String(data: response.data!, encoding: String.Encoding.utf8)!)
                result([])
            }
        }
        
    }
    
    private func manageResponse(dic: NSDictionary) -> [MoneyEntry] {
        var sales: [MoneyEntry] = []
        if let documents = dic["documents"] as? NSArray {
            documents.forEach { item in
                if let value = item as? NSDictionary {
                    if let fields = value["fields"] as? NSDictionary {
                        do {
                            sales.append(try MoneyEntry(from: fields))
                        } catch let error as NSError {
                            print("Failed to manageResponse: \(error.localizedDescription)")
                        }
                    }
                }
                
            }
        }
        
        return sales
    }
    
    
}
