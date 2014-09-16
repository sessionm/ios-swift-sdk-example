//
//  AppDelegate.swift
//  SwiftSKTest
//
//  Created by Christopher Cooper on 6/8/14.
//  Copyright (c) 2014 Christopher Cooper. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SessionMDelegate {
                            
    var window: UIWindow?
    var achievement: SMAchievementData?;
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // Override point for customization after application launch.
        
        SessionM.sharedInstance().delegate = self;
        SessionM.sharedInstance().startSessionWithAppID(YOUR SESSIONM KEY HERE);
        SessionM.sharedInstance().logLevel = SMLogLevelDebug;
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func sessionM(sessionM: SessionM, didTransitionToState state: SessionMState)
    {
        if (state.value == SessionMStateStartedOffline.value)
        {
            println("No Session!");
        }
        else if (state.value == SessionMStateStartedOnline.value)
        {
            println("We have a Session!");
        }
        else
        {
            println("Session Stopped");
        }
    }
    
    func sessionM(sessionM: SessionM, shouldAutoPresentAchievement achievement: SMAchievementData) -> Bool
    {
        println("achievement description: \(achievement.description)");
        
        //set to true to enable automatic achievement displays, keep false to display them on your own
        return false;
    }
    
    func sessionM(sessionM:SessionM, didUpdateUnclaimedAchievement achievement:SMAchievementData)
    {
        self.achievement = achievement;
    }
    
    func getCurrentAchievement() -> SMAchievementData?
    {
        return achievement?
    }
    
//    func sessionM(sessionM: SessionM, viewForActivity type: SMActivityType) -> UIView
//    {
//        println("Returned window.subviews[0]");
//        return self.window!.subviews[0] as UIView;
//
//    }
}

