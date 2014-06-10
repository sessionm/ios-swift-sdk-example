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
    
    
    
    init(theData:SMAchievementData){
        super.init(achievmentData:theData);
    }
    
    
    func present(){
    
        var alertView = UIAlertView(title: super.data.name, message: super.data.message, delegate: self, cancelButtonTitle: "Dismiss");
        alertView.addButtonWithTitle("Claim");
        
        self.alertView = alertView;
        
        self.alertView?.show();
        
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


