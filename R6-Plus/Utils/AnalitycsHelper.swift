//
//  AnalitycsHelper.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 28/07/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation
import Crashlytics

enum AnalitycsHelper: String {
    case AppOpened
    case AppClosed
    case DetailComparisonTouched
    case ComparisonTouched
    case ComparisonBuyPremiumTouched
    case ComparisonRestorePremiumTouched
    case ComparisonWatchVideoTouched
    case ComparisonVideoFullyWatched
    case InterstitialVideoFullyWatched
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
    case PremiumBought
    case PremiumBuyCanceled
    case PremiumRestoreTouched
    case PremiumRestored
    case PremiumRestoredFailed
    case PremiumBuyFailed
    case PremiumBuyDisabled
    case ProGamesOpened
    case MatchTouched
    
    func logEvent(obs: String? = nil) {
        var parameters: [String: String]?
        if let obs = obs {
            parameters = ["obs": obs]
        }
        Answers.logCustomEvent(withName: self.rawValue, customAttributes: parameters)
    }
}
