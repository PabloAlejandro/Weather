//
//  SearchesModule.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import UIKit

class SearchesModule {
    
    //build objects
    private let view: SearchesViewController!
    private let presenter: SearchesPresenter = SearchesPresenter()
    private let routing: SearchesRouting = SearchesRouting()
    private let interactor: SearchesInteractor = SearchesInteractor()
    
    init(didSelectLocation:@escaping ((String)->())) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Weather", bundle: Bundle.main)
        view = storyBoard.instantiateViewController(withIdentifier: "SearchesViewController") as! SearchesViewController
        view.presenter = presenter
        
        routing.mainViewController = view
        
        interactor.output = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.routing = routing
        presenter.didSelectLocation = didSelectLocation
    }
    
    func presentInterface(viewController: UIViewController) {
        routing.presentInterface(viewController: viewController, animated: true)
    }
}
