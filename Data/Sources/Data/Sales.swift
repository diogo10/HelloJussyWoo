import Foundation
import Alamofire

public struct Sales : Identifiable {
    public var seq = UUID()
    public var id: String = ""
    public var name: String = ""
    public var type: Int = 1
    public var total: Double = 0.0
    public var date: Date = Date()
    public var client: String = ""
}

extension Sales {
    public init(from: Any) throws {
        let data = from as! NSDictionary
        seq = UUID()
        id = mapStringValue(data["id"] as? NSDictionary)
        name = mapStringValue(data["name"] as? NSDictionary)
        total = mapDoubleValue(data["total"] as? NSDictionary)
        date = data["date"] as? Date ?? Date()
        type = mapIntegerValue(data["type"] as? NSDictionary)
        client =  mapStringValue(data["client"] as? NSDictionary)
    }
    
    private func mapStringValue(_ data: NSDictionary?) -> String {
        return data?["stringValue"] as? String ?? ""
    }
    
    private func mapIntegerValue(_ data: NSDictionary?) -> Int {
        return data?["integerValue"] as? Int ?? 0
    }
    
    private func mapDoubleValue(_ data: NSDictionary?) -> Double {
        return data?["doubleValue"] as? Double ?? 0.0
    }
}


protocol SalesService:  BaseService {
    func getAll(result: @escaping ([Sales]) -> Void)
}


public struct SalesRepository : SalesService {
    
    let baseGoogleCloudUrl = "https://identitytoolkit.googleapis.com/"
    let baseGoogleFirestoreUrl = "https://firestore.googleapis.com/"
    let serverGoogleCloudKey = "AIzaSyCOXsIcGPD75cf41G5R-UE7A2YgZYEtI5E"
    let signInMethod = "v1/accounts:signInWithPassword"
    let getFinanceMethod = "v1/projects/diogoprojects-617e2/databases/(default)/documents/helloJussyFinance"
    
    var authToken: String = token ?? ""
    
    public func getAll(result: @escaping ([Sales]) -> Void) {
    
        let requestURL = "\(baseGoogleFirestoreUrl)\(getFinanceMethod)?key=\(serverGoogleCloudKey)"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(authToken)"
        ]
        
        sessionAuth.request(requestURL, headers: headers).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                //print(value)
                
                if let jsonResult = value as? NSDictionary {
                    result(manageResponse(dic: jsonResult))
                }else  {
                    result([])
                }
                
            case .failure(let error):
                debugPrint("Error: \(error)")
                debugPrint(String(data: response.data!, encoding: String.Encoding.utf8)!)
                result([])
            }
        }
        
    }
    
    private func manageResponse(dic: NSDictionary) -> [Sales] {
        var sales: [Sales] = []
        if let documents = dic["documents"] as? NSArray {
            documents.forEach { item in
                if let value = item as? NSDictionary {
                    if let fields = value["fields"] as? NSDictionary {
                        print(fields)
                        do {
                            sales.append(try Sales(from: fields))
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
