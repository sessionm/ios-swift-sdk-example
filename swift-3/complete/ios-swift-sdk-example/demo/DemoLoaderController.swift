//
//  DemoLoaderController.swift
//  ios-swift-sdk-example
//
//  Copyright © 2016 SessionM. All rights reserved.
//

import UIKit

class DemoLoaderController: SMLoaderController {

    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!

    @IBAction func dismiss(sender: UIButton) {
        dismissPortal();
    }
    @IBAction func retry(sender: UIButton) {
        reloadPortalContent();
    }

    override func updateViewForLoadStatus(status: SMLoaderControllerLoadStatus) {
        var message : String;
        switch (status) {
        case .Loading:
            retryButton.hidden = true;
            message = "Loading...";
            break;
        case .Failed:
            retryButton.hidden = false;
            message = "Could not load content.";
            break;
        case .Unavailable:
            retryButton.hidden = true;
            message = "Network is offline.";
            break;
        }
        statusLabel.text = message;
    }
}
