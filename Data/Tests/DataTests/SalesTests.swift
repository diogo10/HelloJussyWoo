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
    
    func testMapper() {
        var entry = MoneyEntry()
        entry.client = "Test"
        entry.name = "Bolo"
        entry.id = "1601156341631"
        
        let result = MoneyEntryMapper().fields(model: entry)
        
        XCTAssertTrue(result["name"] != nil)
    }
    
    func testAddSuccess()  {
        let e = expectation(description: "ok")
        var entry = MoneyEntry()
        entry.client = "Continente"
        entry.date = Date()
        entry.extras = "no extras"
        entry.name = "Manteiga"
        entry.total = 40.0
        entry.entry = 0.0
        entry.id = "1601156341631"
        entry.location = "Lisboa"
        entry.phone = ""
        entry.month = 8
        entry.year = 2020
        entry.kg = 1.5
        entry.type = 0
        
        repo.addOrUpdate(value: entry) { value in
            XCTAssertTrue(value)
            e.fulfill()
        }
       waitForExpectations(timeout: 5.0, handler: nil)
    }
}
