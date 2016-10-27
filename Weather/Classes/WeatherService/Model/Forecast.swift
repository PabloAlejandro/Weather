//
//  Forecast.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import UIKit

/**
 *  Model for forecast.
 */
struct Forecast: Equatable {
    
    enum Units {
        case Celsius, Farenheit
    }

    struct Coordinate {
        let latitude: Double
        let longitude: Double
    }
    
    struct WeatherInfo: Equatable {
        let identifier: Int
        let main: String
        let description: String
        let icon: URL
    }
    
    var identifier: Int
    var location: String
    var coord: Coordinate
    var weatherInfo: [WeatherInfo]
    var temperature: Float
    var pressure: Float?
    var humidity: Float?
    var temp_min: Float
    var temp_max: Float
    var units: Units = .Farenheit   // Let's limit this to Farenheit for now
}

func ==(lhs: Forecast, rhs: Forecast) -> Bool {
    return lhs.identifier == rhs.identifier
}

func ==(lhs: Forecast.WeatherInfo, rhs: Forecast.WeatherInfo) -> Bool {
    return lhs.identifier == rhs.identifier
}

extension Forecast: JSONDeserializable {
    
    init?(dict: JSONDictionary) {
        // parse dict and update all fields
        guard
            let identifier = dict["id"] as? Int,
            let coord = dict["coord"] as? [String:AnyObject],
            let coordinate = Coordinate(dict: coord),
            let weather = dict["weather"] as? [[String:AnyObject]],
            let main = dict["main"] as? [String:AnyObject],
            let temp = main["temp"] as? Float,
            let pressure = main["pressure"] as? Float,
            let humidity = main["humidity"] as? Float,
            let temp_min = main["temp_min"] as? Float,
            let temp_max = main["temp_max"] as? Float,
            let location = dict["name"] as? String
            else {
                return nil
        }
        
        self.identifier = identifier
        self.coord = coordinate
        self.weatherInfo = weather.flatMap({ WeatherInfo(dict: $0) })
        self.temperature = temp
        self.pressure = pressure
        self.humidity = humidity
        self.temp_min = temp_min
        self.temp_max = temp_max
        self.location = location
    }
}

extension Forecast.Coordinate: JSONDeserializable {
    
    init?(dict: JSONDictionary) {
        // parse dict and update all fields
        guard
            let latitude = dict["lat"] as? Double,
            let longitude = dict["lon"] as? Double
            else {
                return nil
        }
        
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension Forecast.WeatherInfo: JSONDeserializable {
    
    init?(dict: JSONDictionary) {
        // parse dict and update all fields
        guard
            let identifier = dict["id"] as? Int,
            let main = dict["main"] as? String,
            let description = dict["description"] as? String,
            let icon = dict["icon"] as? String
            else {
                return nil
        }
        
        self.identifier = identifier
        self.main = main
        self.description = description
        self.icon = URL(string: "http://openweathermap.org/img/w/\(icon).png")!
    }
}
