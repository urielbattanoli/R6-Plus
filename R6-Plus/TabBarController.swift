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
        navigation.navigationBar.barTintColor = #colorLiteral(red: 0.07450980392, green: 0.1607843137, blue: 0.2274509804, alpha: 1)
        navigation.navigationBar.tintColor = .white
        navigation.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigation.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigation.navigationItem.largeTitleDisplayMode = .always
        navigation.navigationBar.prefersLargeTitles = true
        navigation.navigationBar.isTranslucent = false
        
        viewControllers = [leaderboard, navigation]
    }
}
