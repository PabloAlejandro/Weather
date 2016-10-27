//
//  Client.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import Foundation

// Same environment as production in this case
func shippingAPIClient(env: APIClientEnvironment, token: OAuthTokenData) -> APIClient<APIClientError> {
    func baseURL() -> NSURL {
        switch env {
        case .Stage:
            return NSURL(string: "http://api.openweathermap.org")!
        case .Prod:
            return NSURL(string: "http://api.openweathermap.org")!
        }
    }
    return APIClient(baseURL: baseURL(), signer: oauth_signer(token: token), error: defaultAPIClientErrorHandler())
}

func shippingAPIClient(env: APIClientEnvironment) -> APIClient<APIClientError> {
    func baseURL() -> NSURL {
        switch env {
        case .Stage:
            return NSURL(string: "http://api.openweathermap.org")!
        case .Prod:
            return NSURL(string: "http://api.openweathermap.org")!
        }
    }
    return APIClient(baseURL: baseURL(), error: defaultAPIClientErrorHandler())
}
