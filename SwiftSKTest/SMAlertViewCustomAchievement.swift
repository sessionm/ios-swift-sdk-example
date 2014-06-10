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
    
    var alertView:UIAlertView?;
    var aData:SMAchievementData;
    
    init(theData:SMAchievementData){
        
        self.aData = theData;
        super.init(achievmentData:theData);
        println("SMAlertViewCustom init");
    }
    
    
    func present(){
        println("event called");
        
        /*
            UIAlertView is now deprecated and the SDK should be updated to reflect that
        */
        
        var aView = UIAlertView();
        aView.title = self.aData.name;
        aView.message = self.aData.message;
        aView.delegate = self;
        aView.addButtonWithTitle("Dismiss");
        aView.cancelButtonIndex = 0;
        aView.addButtonWithTitle("Claim");
        
        println("alert view created");
        
        self.alertView = aView;
        if (self.alertView?){
        self.alertView!.show();
        }
    }
    
    func dismiss(){
        if (self.alertView?)
        {
            self.alertView!.dismissWithClickedButtonIndex(0, animated: true);
        }
    }
    
    
    //UIAlertViewDelegate methods
    func didPresentAlertView(alertView: UIAlertView)
    {
        super.notifyPresented();
        println("Notified presented");
    }
    
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
