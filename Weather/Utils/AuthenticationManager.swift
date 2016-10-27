//
//  AuthenticationManager.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import Foundation

class AuthenticationManager {
    
    let accessToken: String = ""    // This doesn't require a token
    let tokenType: String = ""      // This doesn't require a token type
    
    static let sharedInstance = AuthenticationManager()
}

extension AuthenticationManager: OAuthTokenData {}
