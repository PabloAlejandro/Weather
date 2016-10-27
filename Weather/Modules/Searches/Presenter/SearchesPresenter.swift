//
//  SearchesPresenter.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol SearchesEventHandler: class {
    func viewDidLoad()
    func viewDidChangeText(text: String)
    func viewDidSelect(search: String)
    func viewDidPressLocationButton()
    func viewDidPressRemoveHistory()
    func viewDidPressRemoveHistoryAtIndex(index: Int)
}

// We need to subclass from NSObject in order to implement MKLocalSearchCompleterDelegate protocol
class SearchesPresenter: NSObject  {
    weak var view: SearchesView!
    var interactor: SearchesInteractorInput!
    var routing: SearchesRouting!
    var didSelectLocation: ((String)->())!
    let searchCompleter = MKLocalSearchCompleter()
    var results: [String] = []
    var history: [String]
    
    override init() {
        history = History.lastSearches()
        super.init()
        searchCompleter.delegate = self
    }
    
    internal func showWeather(locationName: String) {
        History.addSearch(search: locationName)
        didSelectLocation(locationName)
        routing.popInterface(animated: true)
    }
}

extension SearchesPresenter: SearchesEventHandler {
    
    internal func viewDidLoad() {
        view.setupView(results: [], history: history)
    }
    
    internal func viewDidChangeText(text: String) {
        searchCompleter.queryFragment = text
    }
    
    internal func viewDidSelect(search: String) {
        showWeather(locationName: search)
    }
    
    internal func viewDidPressLocationButton() {
        interactor.getLocation()
    }
    
    func viewDidPressRemoveHistory() {
        History.clear()
        view.updateHistory(history: History.lastSearches())
    }
    
    internal func viewDidPressRemoveHistoryAtIndex(index: Int) {
        guard index < history.count  else { return }
        History.removeSearch(search: history[index])
        history = History.lastSearches()
        view.updateHistory(history: history)
    }
}

extension SearchesPresenter: SearchesInteractorOutput {

    func didGetLocation(location: CLLocation) {

        view.setLoadingViewStatus(status: .Visible(text: NSLocalizedString("Loading...", comment: "")), animated: true)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks: [CLPlacemark]?, error: Error?) in
            guard error == nil, let placemark = placemarks?.first else {
                // Maybe we want to try to get the location again or show a message in here...
                self?.view.setLoadingViewStatus(status: .Hidden, animated: true)
                return
            }
            
            var locationName = ""
            
            // City
            if let city = placemark.addressDictionary!["City"] as? NSString {
                locationName.append(city as String)
                locationName.append(" ")
            }
            
            // Country
            if let country = placemark.addressDictionary!["Country"] as? NSString {
                locationName.append(country as String)
                locationName.append(" ")
            }
            
            self?.view.setLoadingViewStatus(status: .Hidden, animated: true)
            self?.showWeather(locationName: locationName)
        }
    }
    
    func didFailStartingLocation(message: String) {
        let title = NSLocalizedString("Oops! Something went wrong!", comment: "")
        view.showErrorMessage(title: title, message: message)
    }
}

extension SearchesPresenter: MKLocalSearchCompleterDelegate {

    internal func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results.map({$0.title})
        view.updateResults(results: results)
    }
    
    internal func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}
