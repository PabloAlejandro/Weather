//
//  ForecastService.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import UIKit

/// This is responsibile for managing retrieving Forecast
class ForecastService {

    enum ServiceError: Error {
        case APIError(reason: String?)
        case DataError(reason: String?)
    }
    
    private var client: APIClient<APIClientError>!
    
    init(with token: OAuthTokenData) {
        client = shippingAPIClient(env: .Stage, token: token)
    }
    
    init() {
        client = shippingAPIClient(env: .Stage)
    }
    
    /**
     Method to get Service Error from API error
     */
    private func serviceError(apiError error: APIClientError) -> ServiceError {
        switch error {
        case .GenericError:
            return ServiceError.APIError(reason: nil)
        case .InternalError(let error):
            return ServiceError.APIError(reason: error.localizedDescription)
        case .ApplicationError(let info):
            return ServiceError.APIError(reason: info.message)
        }
    }
    
    /**
     Returns weather for a given coordinate.
     */
    func retrieveForecast(latitude: Double, longitude: Double, metric: Bool, completionBlock:@escaping ((Result<Forecast, ServiceError>) -> ())) {
        func getError(apiError error: APIClientError) -> ServiceError {
            return serviceError(apiError: error)
        }
        let operation = client.load(resource: forecastResource(appID: "95d190a434083879a6398aafd54d9e73", latitude: latitude, longitude: longitude, metric: metric)) { result in
            switch result {
            case .Success(let data):
                completionBlock(.Success(data))
            case .Failure(let error):
                completionBlock(.Failure(getError(apiError: error)))
            }
        }
        operation.start()
    }
    
    /**
     Returns weather for a given location.
     */
    func retrieveForecast(location: String, metric: Bool, completionBlock:@escaping ((Result<Forecast, ServiceError>) -> ())) {
        func getError(apiError error: APIClientError) -> ServiceError {
            return serviceError(apiError: error)
        }
        let operation = client.load(resource: forecastResource(appID: "95d190a434083879a6398aafd54d9e73", query: location, metric: metric)) { result in
            switch result {
            case .Success(let data):
                completionBlock(.Success(data))
            case .Failure(let error):
                completionBlock(.Failure(getError(apiError: error)))
            }
        }
        operation.start()
    }
}
