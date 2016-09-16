//
//  ViewController.swift
//  ios-swift-sdk-simple
//
//  Copyright © 2016 SessionM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SessionMDelegate {

    //
    // MARK: SessionM functionality
    //

    let ApiKey = "af114e255e773ac37b54c3c5bbc6b3b519c25717";
    let sessionM = SessionM.sharedInstance();

    func startSession()  {
        sessionM.startSessionWithAppID(ApiKey);
    }

    func startPortal() {

        // Option 1.
        //    Present Portal, default behavior (Use if you will be returning to the ViewController that presented the Portal
        //
        // sessionM.presentActivity(.Portal);

        // Option 2.
        //    Present Portal, but without the Upper Right close button.
        //
        if let portal = SMActivityViewController.newInstanceWithActivityType(.Portal) {
            self.presentViewController(portal, animated: true, completion: nil);
            portal.disableCloseButton();
        }


    }

    //
    // MARK: ViewController Lifecycle
    //

    let alertController = UIAlertController(title: "Starting", message: "Session Stopped", preferredStyle: .Alert);

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(stateChange(_:)), name: SMSessionMDidTransitionToStateNotification, object: nil);
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);

        print("State: \(sessionM.sessionState.rawValue)");
        if (sessionM.sessionState == .Stopped) {
            presentViewController(alertController, animated: true) { }

            startSession();
        }

    }

    func stateChange(sender : NSNotification) {

        switch sessionM.sessionState {
        case .StartedOffline:
            alertController.message = "Session Started, Offline";
        case .StartedOnline:
            alertController.message = "Session Started, Online";
            alertController.dismissViewControllerAnimated(true, completion: { 
                self.startPortal();
            });
        default:
            alertController.message = "Session Stopped";
        }
    }


}

