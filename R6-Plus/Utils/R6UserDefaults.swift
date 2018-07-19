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
    static var openCount: String { return "appOpenCount" }
    static var freeComparison: String { return "freeComparison" }
    static var premiumAccount: String { return "premiumAccount" }
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
    
    var openCount: Int {
        get {
            return userDefaults.integer(forKey: Key.openCount)
        }
        set {
            userDefaults.set(newValue, forKey: Key.openCount)
        }
    }
    
    var freeComparison: Date? {
        get {
            let dateString = userDefaults.string(forKey: Key.freeComparison) ?? ""
            guard let date = Utils.defaultDateFormatter.date(from: dateString) else { return nil }
            return date
        }
        set {
            userDefaults.set(newValue?.toString() ?? "", forKey: Key.freeComparison)
        }
    }
    
    var premiumAccount: Bool {
        get {
            return userDefaults.bool(forKey: Key.premiumAccount)
        }
        set {
            userDefaults.set(newValue, forKey: Key.premiumAccount)
        }
    }
}
