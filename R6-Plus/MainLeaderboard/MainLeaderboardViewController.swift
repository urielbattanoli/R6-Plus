//
//  MainLeaderboardViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 03/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class MainLeaderboardViewController: UIPageViewController {

    private var leaderViewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageViewController()
    }
    
    private func setupPageViewController() {
        view.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.1411764706, blue: 0.2, alpha: 1)
        
        let vc1 = LeaderboardViewController(leaderboardRegion: .global)
        let vc2 = LeaderboardViewController(leaderboardRegion: .apac)
        let vc3 = LeaderboardViewController(leaderboardRegion: .emea)
        let vc4 = LeaderboardViewController(leaderboardRegion: .ncsa)
        leaderViewControllers = [vc1, vc2, vc3, vc4]
        dataSource = self
        
        setViewControllers([leaderViewControllers.first!], direction: .forward, animated: true)
    }
}

extension MainLeaderboardViewController: UIPageViewControllerDataSource {
    
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
