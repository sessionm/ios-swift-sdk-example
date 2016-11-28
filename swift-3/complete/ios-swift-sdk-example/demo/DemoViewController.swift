//
//  ViewController.swift
//  ios-swift-sdk-example
//
//  Copyright © 2016 SessionM. All rights reserved.
//

import UIKit

open class DemoViewController : UIViewController, UITextFieldDelegate, SessionMDelegate {

    let ApiKey = "af114e255e773ac37b54c3c5bbc6b3b519c25717";

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

    open override func viewDidLoad() {
        super.viewDidLoad();

        // Setup the Portal Buttons (Code and Storyboard)
        
        let image = UIImage(named: "portalButton");

        storyboardPortalButton.badgePosition = .left;
        storyboardPortalButton.button.setImage(image, for: UIControlState());

        if let portal = SMPortalButton(type: .custom) {
            portal.frame = CGRect(x: 0, y: 0, width: codePortalButtonHolder.frame.size.width, height: codePortalButtonHolder.frame.size.height);
            codePortalButtonHolder.addSubview(portal);
            portal.button.setImage(image, for: UIControlState());
        }

    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);

        updateUser(nil);

        // Listeners for User and Session State changes.

        NotificationCenter.default.addObserver(self, selector: #selector(updateUser(_:)), name: NSNotification.Name(rawValue: updatedUserInfoNotification), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(stateChange(_:)), name: NSNotification.Name(rawValue: sessionStateTransitionNotification), object: nil);

        // SessionM SessionListener (SessionMDelegate) delegate.  Using these func in this class
        // public func sessionM(sessionM: SessionM, didFailWithError error: NSError)
        // public func sessionM(sessionM: SessionM, shouldAutopresentAchievement achievement: SMAchievementData) -> Bool

        sessionM.delegate = self;

        // Do nothing if Session started and user is active (isRegistered)
        if ((sessionM.sessionState == .startedOnline) || (sessionM.sessionState == .startedOffline) && (sessionM.user.isRegistered)) {
            return;
        }

        // Show alert to give status as it starts
        let weakSelf = self;
        alertController = UIAlertController(title: "Starting", message: "Preparing Session, please wait", preferredStyle: .alert);
        if let alert = alertController {
            alert.addTextField(configurationHandler: { (field : UITextField) in
                field.delegate = weakSelf;
                field.text = "Stopped";
            });
        }
        self.present(alertController!, animated: true) {}

        // If it's not Started, then start the session (Will remember the last user).
        if ((sessionM.sessionState == .startedOffline) || (sessionM.sessionState == .startedOffline)) {
        } else {
            startSession(sessionM);
        }
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: updatedUserInfoNotification), object: nil);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: sessionStateTransitionNotification), object: nil);
    }

    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool { return false; }

    // 
    // MARK: - Achievement triggering (sending events)
    //

    @IBAction func customAchievement(_ sender: UIButton) {
        sessionM.logAction("custom_achieve");
    }

    @IBAction func earnAchievement(_ sender: UIButton) {
        sessionM.logAction("always_achieve");
    }

    @IBAction func customSwitch(_ toggle : UISwitch) {
        if (toggle.isOn) {
            if let sb = storyboard {
                if let controller = sb.instantiateViewController(withIdentifier: "Demo Loader") as? DemoLoaderController {
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

    @IBAction func notificationsToggle(_ sender: UISwitch) {
    }

    @IBAction func sessionButton(_ sender: UIButton) {
        sessionM.startSession(appID: ApiKey);
    }

    //
    // MARK: - SessionM delegate (SessionMDelegate) methods
    //

    open func sessionM(_ sessionM: SessionM, didFailWithError error: Error) {
        UIAlertView(title: "SessionM Issue", message: error.localizedDescription, delegate: self, cancelButtonTitle: "DONE").show();
        if let alert = alertController {
            let textField = alert.textFields![0] as UITextField;
            textField.text = "\(error.localizedDescription)";

            alert.dismiss(animated: true, completion: nil);
            alertController = nil;
        }
        sessionM.logOutUser();
        showState(sessionM, state: sessionM.sessionState);
    }

    // You've earned an achievement, should it show the popup for achievement
    // Consider Custom Achievement

    open func sessionM(_ sessionM: SessionM, shouldAutopresentAchievement achievement: SMAchievementData) -> Bool {

        if (achievement.isCustom) {
            presentCustom(achievement);
        }
        return !achievement.isCustom;
    }

    // Called when Session transitions between States (From Notification SMSessionMDidTransitionToStateNotification)

    func stateChange(_ sender : Notification) {
        showStartupState(sessionM, state: sessionM.sessionState);
    }

    // Show the user's current status (From Notification SMSessionMDidUpdateUserInfoNotification)

    func updateUser(_ sender : Notification?) {

        let user = sessionM.user;

        if (sessionM.user.isRegistered) {
            if let alert = alertController {
                alert.dismiss(animated: true, completion: nil);
                alertController = nil;
            }
        }

        isSignedInLabel.text = user.isLoggedIn ? "Yes" : "No";
        isRegisteredLabel.text = user.isRegistered ? "Yes" : "No";
        customAchievementButton.isEnabled = sessionM.sessionState != .stopped;
        earnAchievementButton.isEnabled = sessionM.sessionState != .stopped;

        showState(sessionM, state: sessionM.sessionState);
    }

    // MARK: - Support funcs

    func presentCustom(_ achievement : SMAchievementData) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CustomAchievement") as! AchievementViewController;
        self.present(vc, animated: true, completion: nil);
        vc.achievement = achievement;
    }

    func showState(_ sessionM : SessionM, state : SessionMState) {
        switch state {
        case .stopped:
            sessionStateLabel.text = "Stopped";
            sessionButton.isHidden = false;
            sessionButton.setTitle("Start Session", for: UIControlState()) ;
        case .startedOffline:
            sessionStateLabel.text = "Started Offline";
            sessionButton.isHidden = true;
        case .startedOnline:
            sessionStateLabel.text = "Started Online";
            sessionButton.isHidden = true;
        }
        sessionButton.sizeToFit();
    }

    func showStartupState(_ sessionM : SessionM, state : SessionMState) {
        if let alert = alertController {
            let textField = alert.textFields![0] as UITextField;
            switch state {
            case .startedOffline:
                textField.text = "Started, Offline";
            case .startedOnline:
                textField.text = "Started, Online";
                alert.dismiss(animated: true, completion: nil);
                alertController = nil;
            default:
                textField.text = "Session Stoppped";
            }
        }
    }

    func startSession(_ sessionM : SessionM) {
        sessionM.shouldAutoUpdateAchievementsList = true;
        sessionM.startSession(appID: ApiKey);
        if let alert = alertController {
            let textField = alert.textFields![0] as UITextField;
            textField.text = "Starting";
        }
    }

}
