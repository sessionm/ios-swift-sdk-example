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
        sessionM.startSession(appID: ApiKey);
    }

    func startPortal() {

        // Option 1.
        //    Present Portal, default behavior (Use if you will be returning to the ViewController that presented the Portal
        //
        // sessionM.presentActivity(.Portal);

        // Option 2.
        //    Present Portal, but without the Upper Right close button.
        //
        if let portal = SMActivityViewController(activityType: .portal) {
            self.present(portal, animated: true, completion: nil);
            portal.disableCloseButton();
        }


    }

    //
    // MARK: ViewController Lifecycle
    //

    let alertController = UIAlertController(title: "Starting", message: "Session Stopped", preferredStyle: .alert);

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(stateChange(_:)), name: NSNotification.Name(rawValue: sessionStateTransitionNotification), object: nil);
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);

        print("State: \(sessionM.sessionState.rawValue)");
        if (sessionM.sessionState == .stopped) {
            present(alertController, animated: true) { }

            startSession();
        }

    }

    func stateChange(_ sender : Notification) {

        switch sessionM.sessionState {
        case .startedOffline:
            alertController.message = "Session Started, Offline";
        case .startedOnline:
            alertController.message = "Session Started, Online";
            alertController.dismiss(animated: true, completion: { 
                self.startPortal();
            });
        default:
            alertController.message = "Session Stopped";
        }
    }


}

