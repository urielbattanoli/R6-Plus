//
//  MainPageViewController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 03/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

protocol ContentPageViewControllerDelegate: class {
    func page(_ page: UIViewController, didChangeToPosition position: Int)
}

class MainPageViewController: UIPageViewController {

    // MARK: - Properties
    var leaderViewControllers: [UIViewController] = [] {
        didSet {
            guard let vc1 = leaderViewControllers.first else { return }
            setViewControllers([vc1], direction: .forward, animated: true)
        }
    }
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
        dataSource = self
        delegate = self
    }
    
    func changePage(toPosition position: Int) {
        let direction: UIPageViewController.NavigationDirection
        
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
extension MainPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = leaderViewControllers.firstIndex(of: viewController),
            index - 1 >= 0 else { return nil }
        
        return leaderViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = leaderViewControllers.firstIndex(of: viewController),
            index + 1 < leaderViewControllers.count else { return nil }
        
        return leaderViewControllers[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate
extension MainPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard finished, let currentVC = pageViewController.viewControllers?.first as? UBTableViewController else { return }
        pageDelegate?.page(currentVC, didChangeToPosition: currentVC.index)
    }
}
