//
//  MainLeaderboardViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 21/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class MainLeaderboardViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var menuHeader: MenuHeaderMain!
    
    // MARK: - Propertiers
    var pageViewController: LeaderboardPageViewController!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        menuHeader.items = [LeaderboardRegion.global.menuName(),
                            LeaderboardRegion.apac.menuName(),
                            LeaderboardRegion.emea.menuName(),
                            LeaderboardRegion.ncsa.menuName()]
        menuHeader.delegate = self
    }
    
    // MARK: - Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let pageViewController = segue.destination as? LeaderboardPageViewController else { return }
        pageViewController.pageDelegate = self
        self.pageViewController = pageViewController
    }
    
    // MARK: - IBAction
    @IBAction private func searchTouched() {
        SearchRouter.openSearch(viewController: self)
    }
}

// MARK: - MenuHeaderMainDelegate
extension MainLeaderboardViewController: MenuHeaderMainDelegate {
    
    func button(_ button: UIButton, didChangeToPosition position: Int) {
        pageViewController.changePage(toPosition: position)
    }
}

// MARK: - ContentPageViewControllerDelegate
extension MainLeaderboardViewController: ContentPageViewControllerDelegate {
    
    func page(_ page: UIViewController, didChangeToPosition position: Int) {
        menuHeader.animateMenu(withPosition: position)
    }
}
