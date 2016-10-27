//
//  ForecastPresenter.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import UIKit

protocol ForecastEventHandler: class {
    func viewDidLoad()
    func viewDidPressSearch()
    func viewDidPressReload()
}

class ForecastPresenter  {
    weak var view: ForecastView!
    var interactor: ForecastInteractorInput!
    var routing: ForecastRouting!
    
    internal func getWeather(location: String) {
        view.setLoadingViewStatus(status: .Visible(text: NSLocalizedString("Loading...", comment: "")), animated: true)
        // We retrieve information for the last search
        interactor.getForecast(location: location)
    }
}

extension ForecastPresenter: ForecastEventHandler {
    
    internal func viewDidLoad() {
        if let search = History.lastSearch() {
            getWeather(location: search)
        } else {
            // We go to location search
            view.updateModel(model: nil)
        }
    }
    
    func viewDidPressSearch() {
        
        let searchesModule = SearchesModule { [weak self] (search) in
            guard let weakSelf = self else { return }
            weakSelf.interactor.getForecast(location: search)
        }
        routing.pushSearchesModule(module: searchesModule)
    }
}

extension ForecastPresenter: ForecastInteractorOutput {

    internal func didGetForecast(forecast: Forecast) {
        
        view.setLoadingViewStatus(status: .Hidden, animated: true)
        
        guard let humidity = forecast.humidity, let pressure = forecast.pressure else { return }
        
        var units: ForecastViewModel.TemperatureUnits
        // This check is useless as it is, but it is be useful if we want to support Celsius too
        switch forecast.units {
        default:
            units = .Farenheit
        }
        
        let forecastModel = ForecastViewModel(temperatureUnits: units, temperature: String(forecast.temperature), humidity: String(describing: humidity), pressure: String(describing: pressure), location: forecast.location, weatherImageURL: forecast.weatherInfo.first?.icon)
        
        view.updateModel(model: forecastModel)
    }
    
    internal func didFailGettingForecast(errorMessage: String?) {
        view.setLoadingViewStatus(status: .Hidden, animated: true)
        let title: String = NSLocalizedString("Oops! Something went wrong", comment: "")
        if let value = errorMessage {
            view.showErrorMessage(title: title, message: value)
        } else {
            view.showErrorMessage(title: title, message: "Operation failed.")
        }
    }
    
    internal func viewDidPressReload() {
        if let search = History.lastSearch() {
            getWeather(location: search)
        }
    }
}
