//
//  AchievementViewController.swift
//  sdk-ios-sample
//
//  Copyright © 2016 SessionM. All rights reserved.
//

import UIKit

public class AchievementViewController: UIViewController {

    @IBOutlet weak var achievementIcon: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var pointsLabel: UILabel!

    var _achievement : SMAchievementData?;
    var _achievementActivity : SMAchievementActivity?;

    public var achievement : SMAchievementData? {
        set {
            _achievement = newValue;
            if let achieveData = _achievement {
                _achievementActivity = SMAchievementActivity(achievementData: achieveData);
                if let achieve = _achievementActivity {
                    achieve.notifyPresented();
                }
                showAchieve(achieveData);
            }
        }
        get { return nil; }
    };

    func showAchieve(achievement : SMAchievementData) {
        messageLabel.text = achievement.message;
        nameLabel.text = achievement.name;
        pointsLabel.text = "\(achievement.pointValue)";

        if let url = achievement.achievementIconURL {
            loadFromUrl(url) { (image : UIImage?) in
                if let draw = image {
                    self.achievementIcon.image = draw;
                }
            }
        }
    }

    @IBAction func onClaim(sender: UIButton) {
        self.presentingViewController!.dismissViewControllerAnimated(true, completion: {
            if let achieve = self._achievementActivity {
                achieve.notifyDismissed(.Claimed);
            }
        });
    }

    @IBAction func onCancel(sender: UIButton) {
        if let achieve = _achievementActivity {
            achieve.notifyDismissed(.Canceled);
        }
        [self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)];
    }

    // Not optimal, but gets URL load off UI Thread
    func loadFromUrl(url : String, callback : (UIImage? -> Void)) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(queue) {
            if let imageData = NSData(contentsOfURL: NSURL(string: url)!) {
                let image = UIImage(data: imageData);
                dispatch_async(dispatch_get_main_queue(), {
                    callback(image);
                });
            }
        }
    }

}
