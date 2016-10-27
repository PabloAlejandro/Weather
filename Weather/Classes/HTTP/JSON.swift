//
//  JSON.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import Foundation

// Here are some convenience functions for dealing with JSON APIs

public typealias JSONDictionary = [String:AnyObject]

public func decodeJSON(data: NSData) -> JSONDictionary? {
    return (try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions())) as? JSONDictionary
}

public func decodeJSONArray(data: NSData) -> [JSONDictionary]? {
    return (try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions())) as? [JSONDictionary]
}

public func encodeJSON(dict: JSONDictionary) -> NSData? {
    return try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions()) as NSData?
}

/**
 *  A generic interface for initializing any type with a json dictionary. 
 */
public protocol JSONDeserializable {
    init?(dict: JSONDictionary)
}

extension HTTPResource {
    init(path: String, method: HTTPMethod, queryParams: [String: String] = [:], requestParameters: JSONDictionary = [:], checkStatusCode: @escaping (Int) -> Bool, parse: @escaping (JSONDictionary) -> A?) {
        self.path = path
        self.method = method
        self.queryParams = queryParams
        self.parse = { decodeJSON(data: $0).flatMap(parse) }
        self.requestBody = encodeJSON(dict: requestParameters)
        self.headers = ["Content-Type": "application/json"]
        self.checkStatusCode = checkStatusCode
    }
}

extension HTTPResource where A: JSONDeserializable {
    init(path: String, method: HTTPMethod, queryParams: [String: String] = [:], requestParameters: JSONDictionary = [:], checkStatusCode: @escaping (Int) -> Bool, parse: @escaping ((JSONDictionary) -> A?) = A.init) {
        self.path = path
        self.method = method
        self.queryParams = queryParams
        self.parse = { decodeJSON(data: $0).flatMap(parse) }
        self.requestBody = encodeJSON(dict: requestParameters)
        self.headers = ["Content-Type": "application/json"]
        self.checkStatusCode = checkStatusCode
    }
}

extension HTTPResource where A: Sequence, A.Iterator.Element: JSONDeserializable {
    init(path: String, method: HTTPMethod, queryParams: [String: String] = [:], requestParameters: JSONDictionary = [:], checkStatusCode: @escaping (Int) -> Bool, parseItem: @escaping ((JSONDictionary) -> A.Iterator.Element?) = A.Iterator.Element.init) {
        self.path = path
        self.method = method
        self.queryParams = queryParams
        self.parse = { data in
            if let parsed = decodeJSONArray(data: data) {
                let items = parsed.flatMap(parseItem)
                return items as? A
            }
            return nil
        }
        self.requestBody = encodeJSON(dict: requestParameters)
        self.headers = ["Content-Type": "application/json"]
        self.checkStatusCode = checkStatusCode
    }
}

//extension HTTPResource where A: EmptyJSON {
//    init(path: String, method: HTTPMethod, queryParams: [String: String] = [:], requestParameters: JSONDictionary = [:], checkStatusCode: Int -> Bool) {
//        self.path = path
//        self.method = method
//        self.parse = { _ in
//            return A.init()
//        }
//        self.queryParams = queryParams
//        self.requestBody = encodeJSON(requestParameters)
//        self.headers = ["Content-Type": "application/json"]
//        self.checkStatusCode = checkStatusCode
//    }
//}
