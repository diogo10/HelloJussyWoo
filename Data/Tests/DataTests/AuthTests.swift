import XCTest
@testable import Data

final class AuthTests: XCTestCase {
    
    let repo = AuthRepository()
    
    func testLoginError() {
         let e = expectation(description: "error")
        repo.signIn(email: "diogjp10@gmail.com", password: ""){ value in
            XCTAssertNil(value)
            e.fulfill()
            
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testLoginSuccess() {
         let e = expectation(description: "ok")
        repo.signIn(email: "diogjp10@gmail.com", password: "123456"){ value in
            XCTAssertNotNil(value)
            e.fulfill()
            
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
