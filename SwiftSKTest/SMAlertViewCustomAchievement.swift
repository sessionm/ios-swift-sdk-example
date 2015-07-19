//
//  SMAlertViewCustomAchievement.swift
//  SwiftSKTest
//
//  Created by Chris Cooper on 6/10/14.
//  Copyright (c) 2014 Christopher Cooper. All rights reserved.
//

import Foundation
import UIKit

class SMAlertViewCustomAchievement : SMAchievementActivity, UIAlertViewDelegate
{
    //optional because it is not assigned at init
    var alertView:UIAlertView?;
    
    //init the superclass
    init(theData:SMAchievementData){
        super.init(achievementData:theData);
        println("SMAlertViewCustom init");
    }
    // presents the alert view
    func present(){
        /*
            UIAlertView is now deprecated and the SDK should be updated to reflect that
            If you try to use UIAlertView's init function you will run into a segfault
        */
        
        //construct alert view with achievement data
        var aView = UIAlertView();
        aView.title = super.data.name;
        aView.message = super.data.message;
        aView.delegate = self;
        aView.addButtonWithTitle("Dismiss");
        //important to set the cancel button index here
        aView.cancelButtonIndex = 0;
        aView.addButtonWithTitle("Claim");
        
        self.alertView = aView;
        //optionals must be checked before they are unwrapped
        if ((self.alertView) != nil){
        self.alertView!.show();
            
        }
    }
    func dismiss(){
        if ((self.alertView) != nil)
        {
            self.alertView!.dismissWithClickedButtonIndex(0, animated: true);
        }
    }
    
    //UIAlertViewDelegate methods
    
    //call the SMAchievementActivity superclass to notify us that the user was presented with an achievement
    func didPresentAlertView(alertView: UIAlertView)
    {
        super.notifyPresented();
    }
    
    //call the SMAchievementActivity superclass to notify us that the user dismissed the achievement either by cancelling it or by claiming it
    func alertView(alertView:UIAlertView, didDismissWithButtonIndex buttonIndex:NSInteger)
    {
        self.alertView = nil;
        if (buttonIndex == 0)
        {
            super.notifyDismissed(SMAchievementDismissTypeCanceled);
        }
        else if (buttonIndex == 1)
        {
            super.notifyDismissed(SMAchievementDismissTypeClaimed);
        }
    }
}
