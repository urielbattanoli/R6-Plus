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
    }
    
    private func setupTabBar() {
        let storyboard = UIStoryboard(name: "Leaderboard", bundle: nil)
        let leaderboard = storyboard.instantiateInitialViewController()
        leaderboard?.tabBarItem = UITabBarItem(title: "Leaderboard", image: #imageLiteral(resourceName: "unlist"), selectedImage: #imageLiteral(resourceName: "list"))
        
        let presenter = FavoritesPresenter()
        let favorites = UBTableViewController(presenter: presenter)
        favorites.tabBarItem = UITabBarItem(title: "Favorites", image: #imageLiteral(resourceName: "unfavorited"), selectedImage: #imageLiteral(resourceName: "favorited"))
        favorites.title = "Favorites"
        let navigation = UINavigationController(rootViewController: favorites)
        navigation.defaultConfiguration()
        
        let premiumVC = PremiumAccountViewController()
        premiumVC.tabBarItem = UITabBarItem(title: "Premium", image: #imageLiteral(resourceName: "account"), selectedImage: #imageLiteral(resourceName: "filled_account"))
        premiumVC.title = "Premium"
        // To avoid force unwrap on leaderboard instantiateInitialViewController
        viewControllers = [leaderboard, navigation, premiumVC].compactMap { $0 }
    }
}
