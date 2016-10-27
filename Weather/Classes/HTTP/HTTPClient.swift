//
//  HTTPClient.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import Foundation

// MARK: - HTTP Client interfaces

// See the accompanying blog post: http://chris.eidhof.nl/posts/tiny-networking-in-swift.html
// Downloaded from: https://gist.github.com/Arvkon/9ad7d9e83ac65634f5df8557746f4978/f1809bb2a96463872feacd4a043b44520b2dc1c0

class HTTPClient {
    let baseURL: NSURL
    let session: URLSession
    var loggers: [HTTPRequestLogger]
    
    init(baseURL: NSURL, session: URLSession = URLSession.shared) {
        self.baseURL = baseURL
        self.session = session
        self.loggers = [ HTTPConsoleLogger() ]
    }
    
    func request<A>(modifyRequest: ((HTTPRequest) -> ())? = nil, resource: HTTPResource<A>, result: @escaping (Result<A, HTTPRequestError>) -> ()) -> HTTPClientOperation {
        // create request
        let request = createRequest(baseURL: baseURL, resource: resource)
        // modify request (optional)
        modifyRequest?(request)
        
        func complete(request: HTTPRequest, withResult resultValue: Result<A, HTTPRequestError>) {
            // log result
            loggers.forEach { $0.log(event: .RequestResult(request: request, result: resultValue), resource: resource) }
            // notify handler
            result(resultValue)
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            // check for valid response
            guard let httpResponse = response as? HTTPURLResponse else {
                if let error = error {
                    complete(request: request, withResult: .Failure(HTTPRequestError.Other(error as NSError)))
                } else {
                    complete(request: request, withResult: .Failure(.NoData))
                }
                return
            }
            // check for data in response
            guard let responseData = data else {
                complete(request: request, withResult: .Failure(.NoData))
                return
            }
            let headers = httpResponse.allHeaderFields
            // check status code
            if resource.checkStatusCode(httpResponse.statusCode) == false {
                complete(request: request, withResult: .Failure(HTTPRequestError.NoSuccessStatusCode(statusCode: httpResponse.statusCode, data: responseData as NSData, headers: headers as HTTPRequestError.ResponseHeaders)))
                return
            }
            // try to parse data
            guard let parsedData = resource.parse(responseData as NSData) else {
                complete(request: request, withResult: .Failure(HTTPRequestError.CouldNotParseResponse(data: responseData as NSData, headers: headers as HTTPRequestError.ResponseHeaders)))
                return
            }
            // return parsed data
            complete(request: request, withResult: .Success(parsedData))
        }
        return task
        
        
    }
}

/**
 The error type for an http request
 
 - NoData:                The request completed without returning any data
 - NoSuccessStatusCode:   The request completed with an invalid status code, attached.
 - CouldNotParseResponse: The request completed but the response could not be parsed.
 - Other:                 The request failed to completed. The error is attached.
 */
public enum HTTPRequestError: Error {
    public typealias ResponseHeaders = [NSObject : AnyObject]
    case NoData
    case NoSuccessStatusCode(statusCode: Int, data: NSData, headers: ResponseHeaders)
    case CouldNotParseResponse(data: NSData, headers: ResponseHeaders)
    case Other(NSError)
}

/// An interface used to descibe an http request.
public protocol HTTPRequest: class {
    var url: URL? { get set }
    var method: String? { get }
    var allHTTPHeaderFields: [String : String]? { get set }
    func setValue(_ value: String?, forHTTPHeaderField field: String)
    func addValue(_ value: String, forHTTPHeaderField field: String)
    var httpBody: Data? { get set }
}

/**
 *  An interface which describes the type of object created when a new request is dispatched to the client.
 */
public protocol HTTPClientOperation {
    func start()
    func cancel()
}

// MARK: - Internal support
extension NSMutableURLRequest: HTTPRequest {
    public var method: String? {
        get {
            return httpMethod
        }
    }
}

extension URLSessionTask: HTTPClientOperation {
    
    public func start() {
        resume()
    }
}

private func createRequest<A>(baseURL: NSURL, resource: HTTPResource<A>) -> NSMutableURLRequest {
    let url = { () -> NSURL in
        let components = NSURLComponents(url: baseURL as URL, resolvingAgainstBaseURL: false)!
        if let path = components.path {
            components.path = path + "/" + resource.path
        } else {
            components.path = resource.path
        }
        var items = [NSURLQueryItem]()
        for (key, value) in resource.queryParams {
            items.append(NSURLQueryItem(name: key, value: value))
        }
        components.queryItems = items as [URLQueryItem]?
        return components.url! as NSURL
    }()
    let request = NSMutableURLRequest(url: url as URL)
    request.httpMethod = resource.method.rawValue
    request.httpBody = resource.method.dataAllowedOnBody() ? resource.requestBody as? Data : nil
    for (key, value) in resource.headers {
        request.setValue(value, forHTTPHeaderField: key)
    }
    return request
}
