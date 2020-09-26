import XCTest
@testable import Data

final class SalesTests: XCTestCase {
    
    let repo = MoneyEntryRepository()
    
    func testGetSuccess() {
         let e = expectation(description: "error")
        repo.getAll { result in
            XCTAssertFalse(result.isEmpty)
            e.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
