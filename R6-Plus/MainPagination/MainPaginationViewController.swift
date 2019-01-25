//
//  MainPaginationViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 21/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

struct MainPaginationViewModel {
    let menuItems: [String]
    let viewControllers: [UIViewController]
}

protocol MainPaginationView: class {
    func setupView(viewModel: MainPaginationViewModel)
}

class MainPaginationViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var menuHeader: MenuHeaderMain!
    
    // MARK: - Propertiers
    var pageViewController: MainPageViewController!
    var presenter: MainPaginationPresenter?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        menuHeader.delegate = self
        presenter?.attachView(self)
    }
    
    // MARK: - Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let pageViewController = segue.destination as? MainPageViewController else { return }
        pageViewController.pageDelegate = self
        self.pageViewController = pageViewController
    }
    
    // MARK: - IBAction
    @IBAction private func searchTouched() {
        SearchRouter.openSearch(viewController: self)
    }
}

// MARK: - MenuHeaderMainDelegate
extension MainPaginationViewController: MenuHeaderMainDelegate {
    
    func button(_ button: UIButton, didChangeToPosition position: Int) {
        pageViewController.changePage(toPosition: position)
    }
}

// MARK: - ContentPageViewControllerDelegate
extension MainPaginationViewController: ContentPageViewControllerDelegate {
    
    func page(_ page: UIViewController, didChangeToPosition position: Int) {
        menuHeader.animateMenu(withPosition: position)
    }
}

// MAKR: - MainPaginationView
extension MainPaginationViewController: MainPaginationView {
    
    func setupView(viewModel: MainPaginationViewModel) {
        menuHeader.items = viewModel.menuItems
        pageViewController.leaderViewControllers = viewModel.viewControllers
    }
}
