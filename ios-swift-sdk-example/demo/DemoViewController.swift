//
//  ViewController.swift
//  ios-swift-sdk-example
//
//  Copyright © 2016 SessionM. All rights reserved.
//

import UIKit

public class DemoViewController : UIViewController, UITextFieldDelegate, SessionMDelegate {

    let ApiKey = "abd86968d39cc96ff90ffc3164d5b9030d3d2bfd";

    let sessionM = SessionM.sharedInstance();

    var alertController : UIAlertController?;

    @IBOutlet weak var storyboardPortalButton: SMPortalButton!
    @IBOutlet weak var codePortalButtonHolder: UIView!
    
    @IBOutlet weak var earnAchievementButton: UIButton!
    @IBOutlet weak var customAchievementButton: UIButton!
    @IBOutlet weak var isSignedInLabel: UILabel!
    @IBOutlet weak var isRegisteredLabel: UILabel!
    @IBOutlet weak var sessionStateLabel: UILabel!
    @IBOutlet weak var sessionButton: UIButton!

    public override func viewDidLoad() {
        super.viewDidLoad();

        // Setup the Portal Buttons (Code and Storyboard)
        
        let image = UIImage(named: "portalButton");

        storyboardPortalButton.badgePosition = .Left;
        storyboardPortalButton.button.setImage(image, forState: .Normal);

        if let portal = SMPortalButton(type: .Custom) {
            portal.frame = CGRectMake(0, 0, codePortalButtonHolder.frame.size.width, codePortalButtonHolder.frame.size.height);
            codePortalButtonHolder.addSubview(portal);
            portal.button.setImage(image, forState: .Normal);
        }

    }

    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);

        updateUser(nil);

        // Listeners for User and Session State changes.

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateUser(_:)), name: SMSessionMDidUpdateUserInfoNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(stateChange(_:)), name: SMSessionMDidTransitionToStateNotification, object: nil);

        // SessionM SessionListener (SessionMDelegate) delegate.  Using these func in this class
        // public func sessionM(sessionM: SessionM, didFailWithError error: NSError)
        // public func sessionM(sessionM: SessionM, shouldAutopresentAchievement achievement: SMAchievementData) -> Bool

        sessionM.delegate = self;

        // Do nothing if Session started and user is active (isRegistered)
        if ((sessionM.sessionState == .StartedOnline) || (sessionM.sessionState == .StartedOffline) && (sessionM.user.isRegistered)) {
            return;
        }

        // Show alert to give status as it starts
        let weakSelf = self;
        alertController = UIAlertController(title: "Starting", message: "Preparing Session, please wait", preferredStyle: .Alert);
        if let alert = alertController {
            alert.addTextFieldWithConfigurationHandler({ (field : UITextField) in
                field.delegate = weakSelf;
                field.text = "Stopped";
            });
        }
        self.presentViewController(alertController!, animated: true) {}

        // If it's not Started, then start the session (Will remember the last user).
        if ((sessionM.sessionState == .StartedOffline) || (sessionM.sessionState == .StartedOffline)) {
        } else {
            startSession(sessionM);
        }
    }

    override public func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        NSNotificationCenter.defaultCenter().removeObserver(self, name: SMSessionMDidUpdateUserInfoNotification, object: nil);
        NSNotificationCenter.defaultCenter().removeObserver(self, name: SMSessionMDidTransitionToStateNotification, object: nil);
    }

    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool { return false; }

    // 
    // MARK: - Achievement triggering (sending events)
    //

    @IBAction func customAchievement(sender: UIButton) {
        sessionM.logAction("custom_achieve");
    }

    @IBAction func earnAchievement(sender: UIButton) {
        sessionM.logAction("always_achieve");
    }

    @IBAction func customSwitch(toggle : UISwitch) {
        if (toggle.on) {
            if let sb = storyboard {
                if let controller = sb.instantiateViewControllerWithIdentifier("Demo Loader") as? DemoLoaderController {
                    if #available(iOS 9.0, *) {
                        controller.loadViewIfNeeded()
                    } else {
                        let _ = controller.view;
                    };
                    sessionM.addCustomLoaderController(controller);
                }
            }
        } else {
            sessionM.removeCustomLoader();
        }
    }

    @IBAction func notificationsToggle(sender: UISwitch) {
    }

    @IBAction func sessionButton(sender: UIButton) {
        sessionM.startSessionWithAppID(ApiKey);
    }

    //
    // MARK: - SessionM delegate (SessionMDelegate) methods
    //

    public func sessionM(sessionM: SessionM, didFailWithError error: NSError) {
        UIAlertView(title: "SessionM Issue", message: error.localizedDescription, delegate: self, cancelButtonTitle: "DONE").show();
        if let alert = alertController {
            let textField = alert.textFields![0] as UITextField;
            textField.text = "\(error.localizedDescription)";

            alert.dismissViewControllerAnimated(true, completion: nil);
            alertController = nil;
        }
        sessionM.logOutUser();
        showState(sessionM, state: sessionM.sessionState);
    }

    // You've earned an achievement, should it show the popup for achievement
    // Consider Custom Achievement

    public func sessionM(sessionM: SessionM, shouldAutopresentAchievement achievement: SMAchievementData) -> Bool {

        if (achievement.isCustom) {
            presentCustom(achievement);
        }
        return !achievement.isCustom;
    }

    // Called when Session transitions between States (From Notification SMSessionMDidTransitionToStateNotification)

    func stateChange(sender : NSNotification) {
        showStartupState(sessionM, state: sessionM.sessionState);
    }

    // Show the user's current status (From Notification SMSessionMDidUpdateUserInfoNotification)

    func updateUser(sender : NSNotification?) {

        let user = sessionM.user;

        if (sessionM.user.isRegistered) {
            if let alert = alertController {
                alert.dismissViewControllerAnimated(true, completion: nil);
                alertController = nil;
            }
        }

        isSignedInLabel.text = user.isLoggedIn ? "Yes" : "No";
        isRegisteredLabel.text = user.isRegistered ? "Yes" : "No";
        customAchievementButton.enabled = user.isRegistered;
        earnAchievementButton.enabled = user.isRegistered;

        showState(sessionM, state: sessionM.sessionState);
    }

    // MARK: - Support funcs

    func presentCustom(achievement : SMAchievementData) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("CustomAchievement") as! AchievementViewController;
        self.presentViewController(vc, animated: true, completion: nil);
        vc.achievement = achievement;
    }

    func showState(sessionM : SessionM, state : SessionMState) {
        switch state {
        case .Stopped:
            sessionStateLabel.text = "Stopped";
            sessionButton.hidden = false;
            sessionButton.setTitle("Start Session", forState: .Normal) ;
        case .StartedOffline:
            sessionStateLabel.text = "Started Offline";
            sessionButton.hidden = true;
        case .StartedOnline:
            sessionStateLabel.text = "Started Online";
            sessionButton.hidden = true;
        }
        sessionButton.sizeToFit();
    }

    func showStartupState(sessionM : SessionM, state : SessionMState) {
        if let alert = alertController {
            let textField = alert.textFields![0] as UITextField;
            switch state {
            case .StartedOffline:
                textField.text = "Started, Offline";
            case .StartedOnline:
                textField.text = "Started, Online";
                alert.dismissViewControllerAnimated(true, completion: nil);
                alertController = nil;
            default:
                textField.text = "Session Stoppped";
            }
        }
    }

    func startSession(sessionM : SessionM) {
        sessionM.shouldAutoUpdateAchievementsList = true;
        sessionM.startSessionWithAppID(ApiKey);
        if let alert = alertController {
            let textField = alert.textFields![0] as UITextField;
            textField.text = "Starting";
        }
    }

}
