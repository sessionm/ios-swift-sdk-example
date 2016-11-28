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

    @IBAction func dismiss(_ sender: UIButton) {
        dismissPortal();
    }
    @IBAction func retry(_ sender: UIButton) {
        reloadPortalContent();
    }

    override func updateView(for status: SMLoaderControllerLoadStatus) {
        var message : String;
        switch (status) {
        case .loading:
            retryButton.isHidden = true;
            message = "Loading...";
            break;
        case .failed:
            retryButton.isHidden = false;
            message = "Could not load content.";
            break;
        case .unavailable:
            retryButton.isHidden = true;
            message = "Network is offline.";
            break;
        }
        statusLabel.text = message;
    }
}
