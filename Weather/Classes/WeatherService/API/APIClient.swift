//
//  APIClient.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import Foundation

enum APIClientEnvironment {
    case Stage
    case Prod
}

class APIClient<E: Error> {
    
    private let internalClient: HTTPClient
    private let signer: (HTTPRequest) -> Void
    private let error: (HTTPRequestError) -> E
    private let operationQueue: DispatchQueue
    
    init(baseURL: NSURL, signer: @escaping (HTTPRequest) -> Void, error: @escaping (HTTPRequestError) -> E, operationQueue: DispatchQueue = DispatchQueue.main) {
        // build internal client
        internalClient = HTTPClient(baseURL: baseURL)
        // save info
        self.signer = signer
        self.error = error
        self.operationQueue = operationQueue
    }
    
    init(baseURL: NSURL, error: @escaping (HTTPRequestError) -> E, operationQueue: DispatchQueue = DispatchQueue.main) {
        // build internal client
        internalClient = HTTPClient(baseURL: baseURL)
        // save info
        self.signer = { _ in }
        self.error = error
        self.operationQueue = operationQueue
    }
    
    func load<A>(resource: HTTPResource<A>, result handler: @escaping (Result<A, E>) -> Void) -> HTTPClientOperation {
        let operation = internalClient.request(modifyRequest: signer, resource: resource) { [weak self] (result: Result<A, HTTPRequestError>) in
            self?.notify(handler: handler, result: result)
        }
        return operation
    }
    
    private func notify<A>(handler: @escaping (Result<A, E>) -> Void, result: Result<A, HTTPRequestError>) {
        switch result {
        case .Failure(let httpError):
            let apiError = error(httpError)
            operationQueue.async() {
                handler(.Failure(apiError))
            }
        case .Success(let response):
            operationQueue.async() {
                handler(.Success(response))
            }
        }
    }
}
