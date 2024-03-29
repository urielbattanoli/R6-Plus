//
//  AdVideoHelper.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 08/09/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import Foundation
import GoogleMobileAds

class AdVideoHelper: NSObject {
    
    static let shared = AdVideoHelper()
    private var interstitial: GADInterstitial?
    private var timer = Timer()
    private var seconds: TimeInterval = 20
    
    func resetTimer() {
        seconds = 20
    }
    
    func setupInterstitial() {
        interstitial = GADInterstitial(adUnitID: ADS_VIDEO_ID)
        interstitial?.load(GADRequest())
        interstitial?.delegate = self
        startTimer()
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    private func reloadInterstitial() {
        seconds = 120
        setupInterstitial()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: seconds,
                                     target: self,
                                     selector: #selector(showVideo),
                                     userInfo: nil,
                                     repeats: false)
    }
    
    @objc func showVideo() {
        guard !R6UserDefaults.shared.premiumAccount, var topController = UIApplication.shared.topViewController,
            interstitial?.isReady == true else { return }
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        
        interstitial?.present(fromRootViewController: topController)
    }
}

// MARK: - GADInterstitialDelegate
extension AdVideoHelper: GADInterstitialDelegate {
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        AnalitycsHelper.InterstitialVideoFullyWatched.logEvent()
        reloadInterstitial()
    }
}
