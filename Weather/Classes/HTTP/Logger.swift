//
//  Logger.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import Foundation

/**
 An event to log
 
 - RequestResult: The request has completed its execution. Attached is the result and the original request.
 */
enum HTTPRequestLoggerEvent<A> {
    case RequestResult(request: HTTPRequest, result: Result<A, HTTPRequestError>)
}

/**
 *  A generic interface for a request logger.
 */
protocol HTTPRequestLogger {
    func log<A>(event: HTTPRequestLoggerEvent<A>, resource: HTTPResource<A>)
}

/**
 *  A concrete implementation of a request logger, which prints the results in the console.
 */
struct HTTPConsoleLogger: HTTPRequestLogger {
    func log<A>(event: HTTPRequestLoggerEvent<A>, resource: HTTPResource<A>) {
        switch event {
        case .RequestResult(let request, let result):
            switch result {
            case .Failure(let error):
                NSLog("<\(type(of: self))> Request: \(request.method) \(request.url!.absoluteString) –– failed with error: \(error).")
            case .Success(let response):
                NSLog("<\(type(of: self))> Request: \(request.method) \(request.url!.absoluteString) –– successfully loaded: \(type(of: response)).")
            }
        }
    }
}
