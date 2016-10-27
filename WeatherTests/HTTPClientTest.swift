//
//  HTTPClientTest.swift
//  WeatherTests
//
//  Created by Pau on 27/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import XCTest
@testable import Weather

class HTTPClientTest: XCTestCase {

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
    
    func testRequestResource_GET() {
        // given a valid json resource
        let resource = HTTPResource<Greeting>(
            path: "greetings",
            method: .GET,
            queryParams: ["language": "en"],
            checkStatusCode: { $0 == 200 }
        )
        session.data = encodeJSON(dict: ["value": "hello" as AnyObject])!
        session.statusCode = 200
        
        func modifyRequest(request: HTTPRequest) {
            // then base url is added correctly
            XCTAssertEqual(request.url?.host!, "test")
            // then path is added correctly
            XCTAssertEqual(request.url?.path, "/greetings")
            // then query string is correct
            XCTAssertEqual(request.url?.query!, "language=en")
            // then body is empty
            XCTAssertNil(request.httpBody)
            // method is correct
            XCTAssertEqual(request.method, "GET")
        }
        
        // when requesting a resource
        let expec = expectation(description: "get json")
        let operation = sut.request(modifyRequest: modifyRequest, resource: resource) { result in
            switch result {
            case .Failure(let error):
                XCTFail("invalid failure \(error)")
            case .Success(let greeting):
                // then handler will be called with valid data
                XCTAssertEqual(greeting.value, "hello")
                expec.fulfill()
            }
        }
        operation.start()
        
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testRequestResource_POST() {
        // given a valid json resource
        let json = ["value": "new hello"]
        let resource = HTTPResource<Greeting>(
            path: "greetings",
            method: .POST,
            queryParams: ["language": "en"],
            requestParameters: json as JSONDictionary,
            checkStatusCode: { $0 == 202 }
        )
        session.data = encodeJSON(dict: json as JSONDictionary)!
        session.statusCode = 202
        
        func modifyRequest(request: HTTPRequest) {
            // then base url is added correctly
            XCTAssertEqual(request.url?.host!, "test")
            // then path is added correctly
            XCTAssertEqual(request.url?.path, "/greetings")
            // then query string is correct
            XCTAssertEqual(request.url?.query!, "language=en")
            // then body is a valid json
            XCTAssertNotNil(request.httpBody)
            XCTAssertNotNil(decodeJSON(data: request.httpBody! as NSData))
            // method is correct
            XCTAssertEqual(request.method, "POST")
        }
        
        // when requesting a resource
        let expec = expectation(description: "post json")
        let operation = sut.request(modifyRequest: modifyRequest, resource: resource) { result in
            switch result {
            case .Failure(let error):
                XCTFail("invalid failure \(error)")
            case .Success(let greeting):
                // then handler will be called with valid data
                XCTAssertEqual(greeting.value, "new hello")
                expec.fulfill()
            }
        }
        operation.start()
        
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    class Greeting: JSONDeserializable {
        let value: String
        
        required init?(dict: JSONDictionary) {
            guard let value = dict["value"] as? String else {
                return nil
            }
            self.value = value
        }
    }

}
