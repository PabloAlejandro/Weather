//
//  SearchesViewController.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import UIKit

enum SectionType: Int {
    case History, Results
}

protocol SearchesView: class, LoadingViewPresentable {
    func setupView(results: [String], history: [String])
    func updateHistory(history: [String])
    func updateResults(results: [String])
    func showErrorMessage(title: String, message: String)
}

class SearchesViewController: UITableViewController {
    var presenter: SearchesEventHandler!
    var results: [String] = []
    var history: [String] = []
    var filteredHistory: [String] = []
    @IBOutlet weak var clearButton: UIButton!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Location search", comment: "")
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.delegate = self
        
        let locationButton = UIBarButtonItem(image: UIImage(named: "Searches/location_arrow"), style: .plain, target: self, action: #selector(didPressLocationButton))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didPressEditButton))
        navigationItem.rightBarButtonItems = [locationButton, editButton]
        
        presenter.viewDidLoad()
    }
    
    internal func didPressLocationButton() {
        presenter.viewDidPressLocationButton()
    }
    
    internal func didPressEditButton() {
        let edit = !tableView.isEditing
        tableView.setEditing(edit, animated: true)
    }
    
    internal func filterContentForSearchText(searchText: String) {
        presenter.viewDidChangeText(text: searchText)
        filteredHistory = history.filter {
            $0.contains(searchText)
        }
        tableView.reloadData()
    }
    
    // MARK - IBAction methods
    
    @IBAction internal func didPressClearHistoryButton(sender: UIButton) {
        presenter.viewDidPressRemoveHistory()
    }
    
    // MARK - UITAbleViewDataSource
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = SectionType(rawValue: section) else {
            return 0
        }
        
        switch section {
        case .Results:
            return results.count
        case .History:
            if searchController.isActive && searchController.searchBar.text != "" {
                return filteredHistory.count
            }
            return history.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SectionType(rawValue: section) else {
            return nil
        }
        
        switch section {
        case .Results:
            return results.count > 0 ? NSLocalizedString("Results", comment: "") : nil
        case .History:
            if searchController.isActive && searchController.searchBar.text != "" {
                return filteredHistory.count > 0 ? NSLocalizedString("History", comment: "") : nil
            } else {
                return history.count > 0 ? NSLocalizedString("History", comment: "") : nil
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let section = SectionType(rawValue: indexPath.section) else {
            return cell
        }
        
        let result: String
        
        switch section {
        case .Results:
            result = results[indexPath.row]
        case .History:
            if searchController.isActive && searchController.searchBar.text != "" {
                result = filteredHistory[indexPath.row]
            } else {
                result = history[indexPath.row]
            }
        }
        
        cell.textLabel?.text = result
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = SectionType(rawValue: indexPath.section) else {
            return
        }
        
        let result: String
        switch section {
        case .Results:
            result = results[indexPath.row]
        case .History:
            result = history[indexPath.row]
        }
        
        searchController.dismiss(animated: true, completion: nil)
        presenter.viewDidSelect(search: result)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        guard let section = SectionType(rawValue: indexPath.section) else {
            return nil
        }
        
        switch section {
        case .History:
            let delete = UITableViewRowAction(style: .destructive, title: "Remove", handler: { (action: UITableViewRowAction, indexPath: IndexPath) in
                tableView.reloadRows(at: [indexPath], with: .fade)
                self.presenter.viewDidPressRemoveHistoryAtIndex(index: indexPath.row)
            })
            return [delete]
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        guard let section = SectionType(rawValue: indexPath.section) else {
            return false
        }
        
        switch section {
        case .Results:
            return false
        case .History:
            return true
        }
    }
}

extension SearchesViewController: UISearchResultsUpdating {
    
    internal func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

extension SearchesViewController: UISearchControllerDelegate {

    public func willPresentSearchController(_ searchController: UISearchController) {
        if tableView.isEditing {
           tableView.setEditing(false, animated: false)
        }
    }
}

extension SearchesViewController: SearchesView {

    internal func setupView(results: [String], history: [String]) {
        self.results = results
        self.history = history
        clearButton.isEnabled = history.count > 0
        tableView.reloadData()
    }
    
    internal func updateHistory(history: [String]) {
        self.history = history
        clearButton.isEnabled = history.count > 0
        tableView.reloadSections(IndexSet(integer: SectionType.History.rawValue), with: .fade)
    }
    
    internal func updateResults(results: [String]) {
        self.results = results
        tableView.reloadSections(IndexSet(integer: SectionType.Results.rawValue), with: .fade)
    }
    
    internal func showErrorMessage(title: String, message: String) {
        let alertAction: AlertAction = AlertAction(title: NSLocalizedString("Ok", comment: ""), style: .Default) { (_) in }
        let info: AlertControllerInfo = AlertControllerInfo(title: title, message: message, style: .Alert, actions: [alertAction])
        presentAlertViewController(fromInfo: info, animated: true, completion: nil)
    }
}
