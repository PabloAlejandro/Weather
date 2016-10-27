//
//  ForecastServiceTest.swift
//  Weather
//
//  Created by Pau on 27/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import XCTest
@testable import Weather

class ForecastServiceTest: XCTestCase {
    
    let service: ForecastService = ForecastService()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() { 
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWeatherByLocation() {
        let location = "Barcelona Spain"
        let expec = expectation(description: "get response")
        service.retrieveForecast(location: location, metric: true) { (result) in
            switch result {
            case .Success(_):
                expec.fulfill()
            case .Failure(let error):
                switch error {
                case .APIError(let reason):
                    XCTFail("invalid failure \(reason)")
                case .DataError(let reason):
                    XCTFail("invalid failure \(reason)")
                }
            }
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testWeatherByCoordinate() {
        let latitude = 1.2345678
        let longitude = 47.2345678
        let expec = expectation(description: "get response")
        service.retrieveForecast(latitude: latitude, longitude: longitude, metric: true) { (result) in
            switch result {
            case .Success(_):
                expec.fulfill()
            case .Failure(let error):
                switch error {
                case .APIError(let reason):
                    XCTFail("invalid failure \(reason)")
                case .DataError(let reason):
                    XCTFail("invalid failure \(reason)")
                }
            }
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
    
}
