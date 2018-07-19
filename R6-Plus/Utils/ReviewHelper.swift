//
//  ReviewHelper.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 18/07/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation
import StoreKit

struct ReviewHelper {
    
    static func incrementAppOpenedCount() {
        R6UserDefaults.shared.openCount += 1
    }
    
    static func askForReviewIfNeeded() {
        guard R6UserDefaults.shared.openCount % 10 == 0 else { return }
        SKStoreReviewController.requestReview()
    }
}
