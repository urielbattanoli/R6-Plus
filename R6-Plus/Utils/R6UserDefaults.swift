//
//  R6UserDefaults.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 17/05/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation

private struct Key {
    static var favorites: String { return "favorites" }
}

class R6UserDefaults {
    
    static let shared = R6UserDefaults()
    private let userDefaults = UserDefaults.standard
    
    var favorites: [[String: Any]] {
        get {
            return userDefaults.array(forKey: Key.favorites) as? [[String: Any]] ?? []
        }
        set {
            userDefaults.set(newValue, forKey: Key.favorites)
        }
    }
}
