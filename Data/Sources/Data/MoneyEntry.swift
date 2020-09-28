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
        entry = mapDoubleValue(data["signal"] as? NSDictionary)
        kg = mapDoubleValue(data["quantity"] as? NSDictionary)
        date = data["date"] as? Date ?? Date()
        type = mapIntegerValue(data["type"] as? NSDictionary)
        client =  mapStringValue(data["client"] as? NSDictionary)
        location =  mapStringValue(data["location"] as? NSDictionary)
        extras =  mapStringValue(data["extras"] as? NSDictionary)
        phone =  mapStringValue(data["phone"] as? NSDictionary)
        month = mapIntegerValue(data["month"] as? NSDictionary)
        year = mapIntegerValue(data["year"] as? NSDictionary)
    }
    
    public init(data: [String : Any]) {
        seq = UUID()
        id = data["id"] as? String ?? ""
        name = data["name"] as? String ?? ""
        total = data["total"] as? Double ?? 0.0
        entry = data["entry"] as? Double ?? 0.0
        kg =  data["quantity"] as? Double ?? 0.0
        date = data["date"] as? Date ?? Date()
        type = data["type"] as? Int ?? 0
        client =  data["client"] as? String ?? ""
        location =  data["location"] as? String ?? ""
        extras = data["extras"] as? String ?? ""
        phone =  data["phone"] as? String ?? ""
        month = data["month"] as? Int ?? 0
        year = data["year"] as? Int ?? 0
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
    public var phone: String = ""
    public var month: Int = 1
    public var year: Int = 1
    public var entry: Double = 0.0
    public var kg: Double = 0.0
}

//MARK: SERVICE

protocol MoneyEntryService {
    func getAll(result: @escaping ([MoneyEntry]) -> Void)
    func getAll(month: Int, year: Int, result: @escaping ([MoneyEntry]) -> Void)
    func addOrUpdate(value: MoneyEntry, result: @escaping (Bool) -> Void)
}

public class MoneyEntryRepository: MoneyEntryService {
    
    let baseGoogleFirestoreUrl = "https://firestore.googleapis.com/"
    let serverGoogleCloudKey = "AIzaSyCOXsIcGPD75cf41G5R-UE7A2YgZYEtI5E"
    let addMethod = "v1/accounts:signInWithPassword"
    let getFinanceMethod = "v1/projects/diogoprojects-617e2/databases/(default)/documents/helloJussyFinance"
    
    private var list: [MoneyEntry] = []
    
    public func addOrUpdate(value: MoneyEntry, result: @escaping (Bool) -> Void) {
        var id = value.id.trimmingCharacters(in: .whitespacesAndNewlines)
        var body = value
        
        if id.isEmpty {
            id = Date().currentTimeMillis().description
            body.id = id
        }
        
        let params: Parameters = [ "fields" :MoneyEntryMapper().fields(model: value)]
        
        let requestURL = "\(baseGoogleFirestoreUrl)\(getFinanceMethod)/\(id)?key=\(serverGoogleCloudKey)"
        let authtoken = token ?? ""
        print("adding authtoken is empty: \(authtoken.isEmpty)")
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(authtoken)"
        ]
    
        
        sessionAuth.request(requestURL, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in
            
            switch response.result {
            case .success(_):
                debugPrint("Success: addOrUpdate")
                result(true)
            case .failure(let error):
                debugPrint("Error: \(error)")
                debugPrint(String(data: response.data!, encoding: String.Encoding.utf8)!)
                result(false)
            }
        }
        
    }
    
    public func getAll(month: Int, year: Int, result: @escaping ([MoneyEntry]) -> Void) {
        if self.list.isEmpty {
            getAll { values in
                result(self.filter(month: month, year: year, values: values))
            }
        }else {
            result(filter(month: month, year: year, values: self.list))
        }
    }
    
    private func filter(month: Int, year: Int,values: [MoneyEntry]) -> [MoneyEntry] {
        return values.filter { item in
            return item.year == year && item.month == month
        }
    }
    
    public func getAll(result: @escaping ([MoneyEntry]) -> Void) {
        let requestURL = "\(baseGoogleFirestoreUrl)\(getFinanceMethod)?key=\(serverGoogleCloudKey)"
        let authtoken = token ?? ""
        print("getting authtoken is empty: \(authtoken.isEmpty)")
        
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


struct MoneyEntryMapper {
    func fields(model: MoneyEntry) -> Parameters {
        var values: [String: Any] = [:]
        
        values.updateValue(mapString(value: model.name), forKey: "name")
        values.updateValue(mapString(value: model.id), forKey: "id")
        values.updateValue(mapString(value: model.client), forKey: "client")
        values.updateValue(mapString(value: model.extras), forKey: "extras")
        values.updateValue(mapString(value: model.location), forKey: "location")
        values.updateValue(mapString(value: model.phone), forKey: "phone")
        
        values.updateValue(mapInteger(value: model.month), forKey: "month")
        values.updateValue(mapInteger(value: model.year), forKey: "year")
        values.updateValue(mapInteger(value: model.type), forKey: "type")
        
        values.updateValue(mapDouble(value: model.entry), forKey: "signal")
        values.updateValue(mapDouble(value: model.total), forKey: "total")
        values.updateValue(mapDouble(value: model.kg), forKey: "quantity")
        
        return values
    }
    
    private func mapString(value: String) -> NSDictionary {
        return ["stringValue":value]
    }
    
    private func mapInteger(value: Int) -> NSDictionary {
        return ["integerValue":value]
    }
    
    private func mapDouble(value: Double) -> NSDictionary {
        return ["doubleValue":value]
    }
}
