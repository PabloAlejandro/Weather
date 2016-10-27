//
//  Resources.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import Foundation

/**
 *  Resource for weather search by coordinate
 */
func forecastResource(appID: String, latitude: Double, longitude: Double, metric: Bool) -> HTTPResource<Forecast> {
    return HTTPResource(
        path: "data/2.5/weather",
        method: .GET,
        queryParams: ["APPID" : appID,
                      "lat" : String(latitude),
                      "lon" : String(longitude),
                      "units" : (metric == true) ? "metric" : "imperial"],
        checkStatusCode: { $0 == 200 }) as HTTPResource<Forecast>
}

/**
 *  Resource for weather search by location name
 */
func forecastResource(appID: String, query: String, metric: Bool) -> HTTPResource<Forecast> {
    return HTTPResource(
        path: "data/2.5/weather",
        method: .GET,
        queryParams: ["APPID" : appID,
                      "q" : query,
                      "units" : (metric == true) ? "metric" : "imperial"],
        checkStatusCode: { $0 == 200 }) as HTTPResource<Forecast>
}
