//
//  MainLeaderboardViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 21/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class MainLeaderboardViewController: UIViewController {
    
    @IBOutlet private weak var menuHeader: MenuHeaderMain!
    
    var pageViewController: LeaderboardPageViewController!
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        menuHeader.items = [LeaderboardRegion.global.menuName(),
                            LeaderboardRegion.apac.menuName(),
                            LeaderboardRegion.emea.menuName(),
                            LeaderboardRegion.ncsa.menuName()]
        menuHeader.delegate = self
        setupSearch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let pageViewController = segue.destination as? LeaderboardPageViewController else { return }
        pageViewController.pageDelegate = self
        self.pageViewController = pageViewController
    }
    
    private func setupSearch() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTouched))
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @objc private func searchTouched() {
        
    }
}

extension MainLeaderboardViewController: MenuHeaderMainDelegate {
    
    func button(_ button: UIButton, didChangeToPosition position: Int) {
        pageViewController.changePage(toPosition: position)
        searchController.becomeFirstResponder()
    }
}

extension MainLeaderboardViewController: ContentPageViewControllerDelegate {
    func page(_ page: UIViewController, didChangeToPosition position: Int) {
        menuHeader.animateMenu(withPosition: position)
    }
}

extension MainLeaderboardViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        //        filteredCandies = candies.filter({( candy : Candy) -> Bool in
        //            return candy.name.lowercased().contains(searchText.lowercased())
        //        })
        //
    }
}
