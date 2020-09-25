import Foundation


public var token: String? = ""

public struct AppDependencies {
    public static var shared = AppDependencies()
    public var token: String?
    public var salesRepo: SalesRepository = SalesRepository()

    private init() { }
    
    public mutating func changeToken(value: String){
        self.token = value
    }
}
