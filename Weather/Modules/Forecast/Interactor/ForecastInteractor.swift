//
//  ForecastInteractor.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import Foundation

protocol ForecastInteractorInput: class {
    // Methods to retrieve data
    func getForecast(latitude: Double, longitude: Double)
    func getForecast(location: String)
}

protocol ForecastInteractorOutput: class {
    // Methods to send data
    func didGetForecast(forecast: Forecast)
    func didFailGettingForecast(errorMessage: String?)
}

class ForecastInteractor {
    
    enum ForecastInteractorError: Error {
        case APIError(reason: String?)
        case DataError(reason: String?)
    }
    
    weak var output: ForecastInteractorOutput!
    let service = ForecastService()
}

extension ForecastInteractor: ForecastInteractorInput {
    
    func getForecast(location: String) {
        service.retrieveForecast(location: location, metric: true) { [weak self] (result) in
            guard let weakSelf = self else { return }
            switch result {
            case .Success(let forecast):
                weakSelf.output.didGetForecast(forecast: forecast)
            case .Failure(let error):
                switch error {
                case .APIError(let reason):
                    weakSelf.output.didFailGettingForecast(errorMessage: reason)
                case .DataError(let reason):
                    weakSelf.output.didFailGettingForecast(errorMessage: reason)
                }
            }
        }
    }
    
    func getForecast(latitude: Double, longitude: Double) {
        service.retrieveForecast(latitude: latitude, longitude: longitude, metric: true) { [weak self] (result) in
            guard let weakSelf = self else { return }
            switch result {
            case .Success(let forecast):
                weakSelf.output.didGetForecast(forecast: forecast)
            case .Failure(let error):
                switch error {
                case .APIError(let reason):
                    weakSelf.output.didFailGettingForecast(errorMessage: reason)
                case .DataError(let reason):
                    weakSelf.output.didFailGettingForecast(errorMessage: reason)
                }
            }
        }
    }
}
