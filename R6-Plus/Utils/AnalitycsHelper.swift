//
//  AnalitycsHelper.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 28/07/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation
import Firebase

enum AnalitycsHelper: String {
    case AppOpened
    case AppClosed
    case DetailComparisonTouched
    case ComparisonTouched
    case ComparisonBuyPremiumTouched
    case ComparisonRestorePremiumTouched
    case ComparisonWatchVideoTouched
    case ComparisonVideoFullyWatched
    case ComparisonBuyCanceled
    case ComparisonDone
    case SearchOpened
    case SearchDone
    case FavoriteOpened
    case FavoritedTouched
    case DetailOpened
    case PremiumOpened
    case PremiumAlertBuyTouched
    case PremiumBuyTouched
    case PremiumBuyed
    case PremiumBuyCanceled
    case PremiumRestoreTouched
    case PremiumRestored
    case PremiumRestoredFailed
    case PremiumBuyFailed
    case PremiumBuyDisabled
    
    func logEvent(obs: String? = nil) {
        var parameters = [
            AnalyticsParameterItemID: "id-\(self.rawValue)",
            AnalyticsParameterItemName: self.rawValue]
        if let obs = obs {
            parameters["obs"] = obs
        }
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: parameters)
    }
}
