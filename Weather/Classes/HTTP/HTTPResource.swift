//
//  HTTPResource.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import Foundation

/**
 *  A generic interface for identifying an http resource.
 */
public struct HTTPResource<A> {
    var path: String
    var method : HTTPMethod
    var queryParams: [String: String]
    var requestBody: NSData?
    var headers : [String:String]
    var checkStatusCode: (Int) -> Bool
    var parse: (NSData) -> A?
}

public enum HTTPMethod: String { // Bluntly stolen from Alamofire
    case OPTIONS = "OPTIONS"
    case GET = "GET"
    case HEAD = "HEAD"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
    
    func dataAllowedOnBody() -> Bool {
        switch self {
        case .DELETE, .PATCH, .POST, .PUT:
            return true
        default:
            return false
        }
    }
}
