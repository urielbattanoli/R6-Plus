//
//  SearchViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 20/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

enum Platform: String {
    case pc = "uplay"
    case ps4 = "psn"
    case xbox = "xbl"
    
    var name: String {
        switch self {
        case .pc: return "PC"
        case .ps4: return "PS4"
        case .xbox: return "XONE"
        }
    }
    
    var id: String {
        switch self {
        case .pc: return "5172a557-50b5-4665-b7db-e3f2e8c5041d"
        case .ps4: return "05bfb3f7-6c21-4c42-be1f-97a33fb5cf66"
        case .xbox: return "98a601e5-ca91-4440-b1c5-753f601a2c90"
        }
    }
    
    var osbor: String {
        switch self {
        case .pc: return "OSBOR_PC_LNCH_A"
        case .ps4: return "OSBOR_PS4_LNCH_A"
        case .xbox: return "OSBOR_XBOXONE_LNCH_A"
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
        
        title = Strings.Search.search
        view.backgroundColor = #colorLiteral(red: 0.07450980392, green: 0.1607843137, blue: 0.2274509804, alpha: 1)
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
        searchController.searchBar.scopeButtonTitles = scopeButtonsLabel.map { $0.name }
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = Strings.Search.search_player
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) { }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let scope = scopeButtonsLabel[searchBar.selectedScopeButtonIndex].rawValue
        filterContentForSearchText(searchText, scope: scope)
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = Platform.pc.rawValue) {
        presenter.searchPlayer(name: searchText, platform: scope)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let scope = scopeButtonsLabel[selectedScope].rawValue
        let text = searchBar.text ?? ""
        filterContentForSearchText(text, scope: scope)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true)
    }
}
