//
//  NSURLSessionMock.swift
//  WeatherTests
//
//  Created by Pau on 27/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import UIKit

class NSURLSessionMock: URLSession {
    var data: NSData?
    var headers: [String: String]?
    var statusCode = 0
    var error: NSError?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {

        // generate fake task object
        let mock = NSURLSessionDataTaskMock()
        mock.completionHandler = completionHandler
        
        // assign a fake response to it
        let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: headers)
        mock.fakeResponse = response
        mock.fakeResponseData = data
        mock.fakeResponseError = error
        
        return mock
    }
}

private class NSURLSessionDataTaskMock: URLSessionDataTask {
    var fakeResponseData: NSData?
    var fakeResponse: URLResponse?
    var fakeResponseError: NSError?
    var completionHandler: NSURLSessionDataTaskCompletionHandler!
    
    override func resume() {
        
        // simulate async behaviour
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            self.completionHandler?(
                self.fakeResponseData as Data?,
                self.fakeResponse,
                self.fakeResponseError
            )
        })
    }
    
    override func suspend() {
        // do nothing
    }
    
    override func cancel() {
        // do nothing
    }
}

private typealias NSURLSessionDataTaskCompletionHandler = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void
