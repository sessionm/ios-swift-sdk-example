//
//  TabBarViewController.swift
//  sdk-ios-sample
//
//  Copyright © 2016 SessionM. All rights reserved.
//

import UIKit

class TabBarViewController : UITabBarController, UITabBarControllerDelegate {

    let sessionM = SessionM.sharedInstance();

    override func viewDidLoad() {
        super.viewDidLoad();
        self.delegate = self;
    }

    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        sessionM.dismissActivity();
        return true;
    }
}