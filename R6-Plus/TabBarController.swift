//
//  TabBarController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 13/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

private typealias strings = Strings.Menu

class TabBarController: UITabBarController {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTabBar()
        ReviewHelper.askForReviewIfNeeded()
        view.backgroundColor = #colorLiteral(red: 0.07450980392, green: 0.1607843137, blue: 0.2274509804, alpha: 1)
    }
    
    private func setupTabBar() {
        let proGames = UBTableViewController(presenter: ProGamesPresenter())
        proGames.tabBarItem = UITabBarItem(title: strings.proGames, image: #imageLiteral(resourceName: "trophy-outline"), selectedImage: #imageLiteral(resourceName: "trophy"))
        proGames.title = strings.proGames
        let proGamesNavigation = UINavigationController(rootViewController: proGames)
        proGamesNavigation.defaultConfiguration()
        
        let storyboard = UIStoryboard(name: "MainPagination", bundle: nil)
        let news = storyboard.instantiateInitialViewController() as? UINavigationController
        (news?.viewControllers.first as? MainPaginationViewController)?.presenter = MainPaginationPresenter(type: .news)
        news?.tabBarItem = UITabBarItem(title: strings.news, image: #imageLiteral(resourceName: "news"), selectedImage: #imageLiteral(resourceName: "filled_news"))
        
        let leaderboard = storyboard.instantiateInitialViewController() as? UINavigationController
        (leaderboard?.viewControllers.first as? MainPaginationViewController)?.presenter = MainPaginationPresenter(type: .leaderboard)
        leaderboard?.tabBarItem = UITabBarItem(title: strings.leaderboard, image: #imageLiteral(resourceName: "unlist"), selectedImage: #imageLiteral(resourceName: "list"))
        
        let favorites = UBTableViewController(presenter: FavoritesPresenter())
        favorites.tabBarItem = UITabBarItem(title: strings.favorites, image: #imageLiteral(resourceName: "unfavorited"), selectedImage: #imageLiteral(resourceName: "favorited"))
        favorites.title = strings.favorites
        let favoritesNavigation = UINavigationController(rootViewController: favorites)
        favoritesNavigation.defaultConfiguration()
        
        let premiumVC = PremiumAccountViewController()
        premiumVC.tabBarItem = UITabBarItem(title: strings.premium, image: #imageLiteral(resourceName: "account"), selectedImage: #imageLiteral(resourceName: "filled_account"))
        premiumVC.title = strings.premium
        // To avoid force unwrap on leaderboard 
        viewControllers = [news, proGamesNavigation, leaderboard, favoritesNavigation, premiumVC].compactMap { $0 }
    }
}
