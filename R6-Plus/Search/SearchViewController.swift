//
//  SearchViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 20/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class SearchViewController: UBTableViewController {
    
    // MARK: - Properties
    private let searchController = UISearchController(searchResultsController: nil)
    private let presenter: SearchPresenterDelegate
    private var scope = "PC"

    // MARK: - Life cycle
    init(presenter: SearchPresenterDelegate) {
        self.presenter = presenter
        
        super.init(presenter: presenter)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        setupSearch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
    }
    
    // MARK: - Functions
    private func setupSearch() {
        searchController.defaultConfiguration()
        searchController.searchBar.scopeButtonTitles = ["PC", "PS4", "XB1"]
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search player"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        presenter.searchPlayer(name: searchText, platform: self.scope)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        scope = searchBar.scopeButtonTitles?[selectedScope] ?? ""
        filterContentForSearchText(searchBar.text ?? "")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true)
    }
}
