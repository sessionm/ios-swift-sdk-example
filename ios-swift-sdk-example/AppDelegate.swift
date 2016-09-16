//
//  AppDelegate.swift
//  ios-swift-sdk-example
//
//  Copyright © 2016 SessionM. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var achievement: SMAchievementData?;

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        SessionM.sharedInstance().logLevel = .Debug;

        return true
    }

    func applicationWillResignActive(application: UIApplication) {}
    func applicationDidEnterBackground(application: UIApplication) {}
    func applicationWillEnterForeground(application: UIApplication) {}
    func applicationDidBecomeActive(application: UIApplication) {}
    func applicationWillTerminate(application: UIApplication) {}

}

// push notifications
// user opt in/out  [Handle start session with opt-out user]


