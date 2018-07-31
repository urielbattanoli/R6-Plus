//
//  TabBarController.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 13/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTabBar()
        if R6UserDefaults.shared.premiumAccount && !R6UserDefaults.shared.premiumAccountVerified {
            R6UserDefaults.shared.premiumAccountVerified = true
            AnalitycsHelper.IsPremiumAccount.logEvent()
        }
    }
    
    private func setupTabBar() {
        let proGames = UBTableViewController(presenter: ProGamesPresenter())
        proGames.tabBarItem = UITabBarItem(title: "Pro Games", image: #imageLiteral(resourceName: "trophy-outline"), selectedImage: #imageLiteral(resourceName: "trophy"))
        proGames.title = "Pro Games"
        let proGamesNavigation = UINavigationController(rootViewController: proGames)
        proGamesNavigation.defaultConfiguration()
        
        let storyboard = UIStoryboard(name: "Leaderboard", bundle: nil)
        let leaderboard = storyboard.instantiateInitialViewController()
        leaderboard?.tabBarItem = UITabBarItem(title: "Leaderboard", image: #imageLiteral(resourceName: "unlist"), selectedImage: #imageLiteral(resourceName: "list"))
        
        let favorites = UBTableViewController(presenter: FavoritesPresenter())
        favorites.tabBarItem = UITabBarItem(title: "Favorites", image: #imageLiteral(resourceName: "unfavorited"), selectedImage: #imageLiteral(resourceName: "favorited"))
        favorites.title = "Favorites"
        let favoritesNavigation = UINavigationController(rootViewController: favorites)
        favoritesNavigation.defaultConfiguration()
        
        let premiumVC = PremiumAccountViewController()
        premiumVC.tabBarItem = UITabBarItem(title: "Premium", image: #imageLiteral(resourceName: "account"), selectedImage: #imageLiteral(resourceName: "filled_account"))
        premiumVC.title = "Premium"
        // To avoid force unwrap on leaderboard instantiateInitialViewController
        viewControllers = [proGamesNavigation, leaderboard, favoritesNavigation, premiumVC].compactMap { $0 }
    }
}
