//
//  UIApplicationExtension.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 08/09/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit

extension UIApplication {
    var topViewController: UIViewController? {
        if keyWindow?.rootViewController == nil{
            return keyWindow?.rootViewController
        }
        
        var pointedViewController = keyWindow?.rootViewController
        
        while  pointedViewController?.presentedViewController != nil {
            switch pointedViewController?.presentedViewController {
            case let navagationController as UINavigationController:
                pointedViewController = navagationController.viewControllers.last
            case let tabBarController as UITabBarController:
                pointedViewController = tabBarController.selectedViewController
            default:
                pointedViewController = pointedViewController?.presentedViewController
            }
        }
        return pointedViewController
    }
}
