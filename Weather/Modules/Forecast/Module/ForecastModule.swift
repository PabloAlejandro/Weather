//
//  ForecastModule.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import UIKit

class ForecastModule {
    
    //build objects
    private let view: ForecastViewController!
    private let presenter: ForecastPresenter = ForecastPresenter()
    private let routing: ForecastRouting = ForecastRouting()
    private let interactor: ForecastInteractor = ForecastInteractor()
    
    init() {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Weather", bundle: Bundle.main)
        view = storyBoard.instantiateViewController(withIdentifier: "ForecastViewController") as! ForecastViewController
        
        view.presenter = presenter
        
        routing.mainViewController = view
        
        interactor.output = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.routing = routing
    }
    
    func presentInterface(navigationController: UINavigationController) {
        routing.presentInterface(navigationController: navigationController, animated: true)
    }
}
