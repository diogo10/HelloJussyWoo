import XCTest
@testable import Data

final class DataTests: XCTestCase {
    
    let repo = WooRepository()
    
    func testOrders() {
         let e = expectation(description: "on-hold")
        
        repo.getOrders(){ values in
            
            values.forEach { (value) in
                XCTAssertNotNil(value.id)
                XCTAssertNotNil(value.status)
                
                XCTAssertNotNil(value.clientName)
                XCTAssertNotNil(value.city)
                XCTAssertNotNil(value.address)
                
                XCTAssertNotNil(value.shippingTotal)
                XCTAssertNotNil(value.createdAt)
                
                XCTAssertNotNil(value.items)
                XCTAssertTrue(value.items.count >= 1)
                
                e.fulfill()
            }
            
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }

    static var allTests = [
        ("testOrders", testOrders),
    ]
}
