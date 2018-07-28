//
//  AppDelegate.swift
//  R6-Plus
//
//  Created by Uriel Battanoli on 13/04/18.
//  Copyright © 2018 Mocka. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase

let ADS_APP_ID = "ca-app-pub-3291479380654020~6866270802"
//let ADS_BANNER_ID = "ca-app-pub-3291479380654020/4653210435"
//let ADS_VIDEO_ID = "ca-app-pub-3291479380654020/3432037228"
let ADS_BANNER_ID = "ca-app-pub-3940256099942544/2934735716" //test
let ADS_VIDEO_ID = "ca-app-pub-3940256099942544/1712485313" //test

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    internal var shouldRotate = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GADMobileAds.configure(withApplicationID: ADS_APP_ID)
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: ADS_VIDEO_ID)
        ReviewHelper.incrementAppOpenedCount()
        AnalitycsHelper.AppOpened.logEvent(obs: "\(R6UserDefaults.shared.openCount)")
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return shouldRotate ? .allButUpsideDown : .portrait
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        AnalitycsHelper.AppClosed.logEvent()
    }
}
