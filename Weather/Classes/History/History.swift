//
//  History.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import Foundation

private let key: String = "last_searches"

class History {

    private class func setLastSearches(lastSearches: [String]?) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(lastSearches, forKey: key)
        defaults.synchronize()
    }
    
    class func addSearch(search: String) {
        var lastSearches = History.lastSearches()
        if let index = lastSearches.index(of: search) {
            lastSearches.remove(at: index)
        }
        lastSearches.append(search)
        History.setLastSearches(lastSearches: lastSearches)
    }
    
    class func removeSearch(search: String) {
        var lastSearches = History.lastSearches()
        if let index = lastSearches.index(of: search) {
            lastSearches.remove(at: index)
        }
        History.setLastSearches(lastSearches: lastSearches)
    }
    
    class func clear() {
        History.setLastSearches(lastSearches: nil)
    }
    
    class func lastSearch() -> String? {
        let defaults: UserDefaults = UserDefaults.standard
        guard let lastSearches = defaults.object(forKey: key) as? [String] else {
            return nil
        }
        return lastSearches.last
    }
    
    class func lastSearches() -> [String] {
        let defaults: UserDefaults = UserDefaults.standard
        guard let lastSearches = defaults.object(forKey: key) as? [String] else {
            return []
        }
        return lastSearches
    }
}
