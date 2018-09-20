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
import OneSignal
import Fabric
import Crashlytics

let ADS_APP_ID = "ca-app-pub-3291479380654020~6866270802"
let ADS_BANNER_ID = "ca-app-pub-3291479380654020/4653210435"
let ADS_COMP_ID = "ca-app-pub-3291479380654020/3432037228"
let ADS_VIDEO_ID = "ca-app-pub-3291479380654020/5840496493"
let ONESIGNAL_APP_ID = "592b29cc-4853-4d42-9e8b-74873f9b8fbb"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    internal var shouldRotate = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()
        GADMobileAds.configure(withApplicationID: ADS_APP_ID)
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(),
                                                    withAdUnitID: ADS_COMP_ID)
        ReviewHelper.incrementAppOpenedCount()
        AnalitycsHelper.AppOpened.logEvent(obs: "\(R6UserDefaults.shared.openCount)")
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: ONESIGNAL_APP_ID,
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
        application.registerForRemoteNotifications()
        OneSignal.promptForPushNotifications() { accepted in
            print("User accepted notifications: \(accepted)")
        }
        TokenHelper.validUbiToken()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return shouldRotate ? .allButUpsideDown : .portrait
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        AnalitycsHelper.AppClosed.logEvent()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AdVideoHelper.shared.setupInterstitial() 
    }
}
