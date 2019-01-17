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
    }
    
    private func setupTabBar() {
        let proGames = UBTableViewController(presenter: ProGamesPresenter())
        proGames.tabBarItem = UITabBarItem(title: strings.proGames, image: #imageLiteral(resourceName: "trophy-outline"), selectedImage: #imageLiteral(resourceName: "trophy"))
        proGames.title = strings.proGames
        let proGamesNavigation = UINavigationController(rootViewController: proGames)
        proGamesNavigation.defaultConfiguration()
        
        let storyboard = UIStoryboard(name: "Leaderboard", bundle: nil)
        let leaderboard = storyboard.instantiateInitialViewController()
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
        viewControllers = [proGamesNavigation, leaderboard, favoritesNavigation, premiumVC].compactMap { $0 }
    }
}
