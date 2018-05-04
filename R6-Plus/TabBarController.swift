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
        let leaderboard = MainLeaderboardViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        leaderboard.tabBarItem = UITabBarItem(title: "Leaderboard", image: nil, selectedImage: nil)
        self.viewControllers = [leaderboard]
    }
    
    @IBAction func Touch(_ sender: Any) {
        navigationController?.pushViewController(LeaderboardViewController(leaderboardRegion: .global), animated: true)
    }
}
