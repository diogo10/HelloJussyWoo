import Foundation
import Alamofire


private let ipAuth = "identitytoolkit.googleapis.com"
private let ipSales = "firestore.googleapis.com"
let sessionAuth: Session = {
    let manager = ServerTrustManager(evaluators: [ipAuth: DisabledTrustEvaluator(), ipSales: DisabledTrustEvaluator()])
    let configuration = URLSessionConfiguration.af.default
    return Session(configuration: configuration, serverTrustManager: manager)
}()

protocol BaseService {}

protocol AuthService {
    func signIn(email: String,password: String, result: @escaping (Bool) -> Void)
}

struct AuthRequest : Encodable {
    var email: String = ""
    var password: String = ""
    var returnSecureToken: Bool = true
}


public class AuthRepository : AuthService {
    let baseGoogleCloudUrl = "https://identitytoolkit.googleapis.com/"
    let serverGoogleCloudKey = "AIzaSyCOXsIcGPD75cf41G5R-UE7A2YgZYEtI5E"
    let signInMethod = "v1/accounts:signInWithPassword"
    let getFinanceMethod = "v1/projects/diogoprojects-617e2/databases/(default)/documents/helloJussyFinance"
    
    public init() {}
    
    ///https://cloud.google.com/identity-platform/docs/use-rest-api#section-create-email-password
    
    public func signIn(email: String, password: String, result: @escaping (Bool) -> Void) {
        
        let requestURL = "\(baseGoogleCloudUrl)\(signInMethod)?key=\(serverGoogleCloudKey)"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let parameters = AuthRequest(email: email, password: password, returnSecureToken: true)
        
        sessionAuth.request(requestURL, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                print(value)
                
                if let jsonResult = value as? NSDictionary {
                    let token = jsonResult["idToken"] as? String ?? ""
                    self.changeToken(value: token)
                    result(true)
                }else  {
                    result(false)
                }
                
            case .failure(let error):
                debugPrint("Error: \(error)")
                debugPrint(String(data: response.data!, encoding: String.Encoding.utf8)!)
                result(false)
            }
        }
    }
    
    
    func changeToken(value: String) {
        token = value
    }
    
    
}
