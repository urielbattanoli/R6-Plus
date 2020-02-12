//
//  SearchRouter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 05/08/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

struct SearchRouter {
    
    static func openSearch(viewController: UIViewController?, presenter: SearchPresenterDelegate) {
        guard let viewController = viewController else { return }
        let searchVC = SearchViewController(presenter: presenter)
        searchVC.modalTransitionStyle = .crossDissolve
        let navigation = UINavigationController(rootViewController: searchVC)
        navigation.view.backgroundColor = #colorLiteral(red: 0.07450980392, green: 0.1607843137, blue: 0.2274509804, alpha: 1)
        navigation.defaultConfiguration()
        viewController.navigationController?.present(navigation, animated: true)
    }
}
