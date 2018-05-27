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
        let leaderboard = storyboard.instantiateInitialViewController()!
        leaderboard.tabBarItem = UITabBarItem(title: "Leaderboard", image: nil, selectedImage: nil)
        
        let presenter = FavoritesPresenter(service: FavoritesService())
        let favorites = UBTableViewController(presenter: presenter)
//        favorites.tabBarItem = UITabBarItem(title: "", image: nil, selectedImage: nil)
        favorites.title = "Favorites"
        let navigation = UINavigationController(rootViewController: favorites)
        navigation.defaultConfiguration()
        viewControllers = [leaderboard, navigation]
    }
}
