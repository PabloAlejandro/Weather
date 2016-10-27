//
//  ForecastViewModel.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import Foundation

struct ForecastViewModel {
    
    enum TemperatureUnits: String {
        case Farenheit = "ºF", Celsius = "ºC"
    }
    
    let temperatureUnits: TemperatureUnits
    let temperature: String
    let humidity: String
    let pressure: String
    let location: String
    let weatherImageURL: URL?
}
