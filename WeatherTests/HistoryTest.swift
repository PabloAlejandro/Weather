//
//  HistoryTest.swift
//  Weather
//
//  Created by Pau on 27/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import XCTest

class HistoryTest: XCTestCase {
    
    let searches = ["search 1", "search 2", "search 3", "search 4"]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        for search in searches {
            History.addSearch(search: search)
        }
        super.tearDown()
    }
    
    func testAddHistory() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(History.lastSearches().count == searches.count, "History searches must contain the same objects as searches!")
        XCTAssertTrue(History.lastSearch() == "search 4", "Last object must be search 4")
    }
    
    func testRemoveHistory() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(History.lastSearches().contains("search 4") == true, "History must contain search 4")
        History.removeSearch(search: "search 4")
        XCTAssertTrue(History.lastSearches().contains("search 4") == false, "History shouldn't contain search 4")
    }
    
    func testClearHistory() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        History.clear()
        XCTAssertTrue(History.lastSearch() == nil, "History must be empty")
    }
}
