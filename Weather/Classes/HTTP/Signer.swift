//
//  Signer.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import Foundation

/**
 *  A generic interface for an oauth token
 */
public protocol OAuthTokenData {
    var accessToken: String { get }
    var tokenType: String { get }
}

/**
 Creates a new oauth signer used to correctly modify a request
 
 - parameter token: The token used to sign the request
 */
public func oauth_signer(token: OAuthTokenData) -> ((HTTPRequest) -> Void) {
    let auth = "\(token.tokenType) \(token.accessToken)"
    return {
        $0.setValue(auth, forHTTPHeaderField: "Authorization")
    }
}
