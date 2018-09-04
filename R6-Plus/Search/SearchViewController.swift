//
//  SearchViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 20/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

fileprivate enum Platform: String {
    case pc = "PC"
    case ps4 = "PS4"
    case xbox = "XONE"
    
    var nameOnServer: String {
        switch self {
        case .pc: return "uplay"
        case .ps4: return "psn"
        case .xbox: return "xbl"
        }
    }
}

class SearchViewController: UBTableViewController {
    
    // MARK: - Properties
    private let searchController = UISearchController(searchResultsController: nil)
    private let presenter: SearchPresenterDelegate
    private let scopeButtonsLabel: [Platform] = [.pc, .ps4, .xbox]

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
        searchController.searchBar.scopeButtonTitles = scopeButtonsLabel.map { $0.rawValue }
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search player"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) { }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let scope = scopeButtonsLabel[searchBar.selectedScopeButtonIndex].nameOnServer
        filterContentForSearchText(searchText, scope: scope)
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = Platform.pc.rawValue) {
        presenter.searchPlayer(name: searchText, platform: scope)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let scope = scopeButtonsLabel[selectedScope].nameOnServer
        let text = searchBar.text ?? ""
        filterContentForSearchText(text, scope: scope)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true)
    }
}
