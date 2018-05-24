//
//  LeaderboardPageViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 03/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

protocol ContentPageViewControllerDelegate: class {
    func page(_ page: UIViewController, didChangeToPosition position: Int)
}

class LeaderboardPageViewController: UIPageViewController {

    // MARK: - Properties
    private var leaderViewControllers: [UIViewController] = []
    private var currentVC = 0
    weak var pageDelegate: ContentPageViewControllerDelegate?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageViewController()
    }
    
    // MARK: - Functions
    private func setupPageViewController() {
        view.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.1411764706, blue: 0.2, alpha: 1)
        let vcd1 = LeaderboardPresenter(service: LeaderboardService(), leaderboardRegion: .global)
        let vc1 = UBTableViewController(presenter: vcd1)
        vc1.index = 0
        let vcd2 = LeaderboardPresenter(service: LeaderboardService(), leaderboardRegion: .apac)
        let vc2 = UBTableViewController(presenter: vcd2)
        vc2.index = 1
        let vcd3 = LeaderboardPresenter(service: LeaderboardService(), leaderboardRegion: .emea)
        let vc3 = UBTableViewController(presenter: vcd3)
        vc3.index = 2
        let vcd4 = LeaderboardPresenter(service: LeaderboardService(), leaderboardRegion: .ncsa)
        let vc4 = UBTableViewController(presenter: vcd4)
        vc4.index = 3
        leaderViewControllers = [vc1, vc2, vc3, vc4]
        dataSource = self
        delegate = self
        
        setViewControllers([vc1], direction: .forward, animated: true)
    }
    
    func changePage(toPosition position: Int) {
        let direction: UIPageViewControllerNavigationDirection
        
        if currentVC > position {
            direction = .reverse
        } else {
            direction = .forward
        }
        
        currentVC = position
        let nextViewController = leaderViewControllers[currentVC]
        setViewControllers([nextViewController], direction: direction, animated: true, completion: nil)
    }
}

// MARK: - UIPageViewControllerDataSource
extension LeaderboardPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = leaderViewControllers.index(of: viewController),
            index - 1 >= 0 else { return nil }
        
        return leaderViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = leaderViewControllers.index(of: viewController),
            index + 1 < leaderViewControllers.count else { return nil }
        
        return leaderViewControllers[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate
extension LeaderboardPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard finished, let currentVC = pageViewController.viewControllers?.first as? UBTableViewController else { return }
        pageDelegate?.page(currentVC, didChangeToPosition: currentVC.index)
    }
}
