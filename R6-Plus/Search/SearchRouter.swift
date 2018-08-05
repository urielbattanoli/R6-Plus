//
//  SearchRouter.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 05/08/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

struct SearchRouter {
    
    static func openSearch(viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        let presenter = SearchPresenter(service: SearchService())
        let searchVC = SearchViewController(presenter: presenter)
        searchVC.modalTransitionStyle = .crossDissolve
        let navigation = UINavigationController(rootViewController: searchVC)
        navigation.defaultConfiguration()
        viewController.navigationController?.present(navigation, animated: true)
    }
}
