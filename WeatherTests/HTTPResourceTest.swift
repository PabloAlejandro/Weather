//
//  HTTPResourceTest.swift
//  WeatherTests
//
//  Created by Pau on 27/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import XCTest
@testable import Weather

class HTTPResourceTest: XCTestCase {

    var sut: HTTPClient!
    var session: NSURLSessionMock!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        session = NSURLSessionMock()
        sut = HTTPClient(baseURL: NSURL(string: "localhost://test")!, session: session)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testResource() {
        
        // given a valid json resource
        let resource = HTTPResource<Mock1>(
            path: "mock",
            method: .GET,
            checkStatusCode: { $0 == 200 },
            parse: { data in
                guard let value = data["value"] as? String else { return nil }
                return Mock1(value: value)
            }
        )
        session.data = encodeJSON(dict: ["value": "hello" as AnyObject])!
        session.statusCode = 200
        
        // when requesting a resource
        let expec = expectation(description: "get json")
        let operation = sut.request(modifyRequest: nil, resource: resource) { result in
            switch result {
            case .Failure(let error):
                XCTFail("invalid failure \(error)")
            case .Success(let mock):
                // then handler will be called with valid data
                XCTAssertEqual(mock.value, "hello")
                expec.fulfill()
            }
        }
        operation.start()
        
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testJSONDeserializableResource() {
        
        // given a valid json resource
        let resource = HTTPResource<Mock2>(
            path: "mock",
            method: .GET,
            checkStatusCode: { $0 == 200 }
        )
        session.data = encodeJSON(dict: ["value": "hello" as AnyObject])!
        session.statusCode = 200
        
        // when requesting a resource
        let expec = expectation(description: "get json")
        let operation = sut.request(modifyRequest: nil, resource: resource) { result in
            switch result {
            case .Failure(let error):
                XCTFail("invalid failure \(error)")
            case .Success(let mock):
                // then handler will be called with valid data
                XCTAssertEqual(mock.value, "hello")
                expec.fulfill()
            }
        }
        operation.start()
        
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testJSONDeserializableArrayResource() {
        
        func encodeJSON(object: AnyObject) -> NSData? {
            return try! JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions()) as NSData?
        }
        
        // given a valid json resource
        let resource = HTTPResource<[Mock2]>(
            path: "mock",
            method: .GET,
            checkStatusCode: { $0 == 200 }
        )
        let dataObject = [["value": "hello1"], ["value": "hello2"], ["value": "hello3"]]
        session.data = encodeJSON(object: dataObject as AnyObject)
        session.statusCode = 200
        
        // when requesting a resource
        let expec = expectation(description: "get json")
        let operation = sut.request(modifyRequest: nil, resource: resource) { result in
            switch result {
            case .Failure(let error):
                XCTFail("invalid failure \(error)")
            case .Success(let mocks):
                // then handler will be called with valid data
                XCTAssertEqual(mocks.count, 3)
                XCTAssertEqual(mocks.first?.value, "hello1")
                expec.fulfill()
            }
        }
        operation.start()
        
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    class Mock1 {
        let value: String
        init(value: String) {
            self.value = value
        }
    }
    
    class Mock2: JSONDeserializable {
        let value: String
        
        required init?(dict: JSONDictionary) {
            guard let value = dict["value"] as? String else {
                return nil
            }
            self.value = value
        }
    }
}
