//
//  AchievementViewController.swift
//  ios-swift-sdk-example
//
//  Copyright © 2016 SessionM. All rights reserved.
//

import UIKit

open class AchievementViewController: UIViewController {

    @IBOutlet weak var achievementIcon: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var pointsLabel: UILabel!

    var _achievement : SMAchievementData?;
    var _achievementActivity : SMAchievementActivity?;

    open var achievement : SMAchievementData? {
        set {
            _achievement = newValue;
            if let achieveData = _achievement {
                _achievementActivity = SMAchievementActivity(data: achieveData);
                if let achieve = _achievementActivity {
                    achieve.notifyPresented();
                }
                showAchieve(achieveData);
            }
        }
        get { return nil; }
    };

    func showAchieve(_ achievement : SMAchievementData) {
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

    @IBAction func onClaim(_ sender: UIButton) {
        self.presentingViewController!.dismiss(animated: true, completion: {
            if let achieve = self._achievementActivity {
                achieve.notifyDismissed(dismissType: .claimed);
            }
        });
    }

    @IBAction func onCancel(_ sender: UIButton) {
        if let achieve = _achievementActivity {
            achieve.notifyDismissed(dismissType: .canceled);
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil);
    }

    // Not optimal, but gets URL load off UI Thread
    func loadFromUrl(_ url : String, callback : @escaping ((UIImage?) -> Void)) {
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated);
        queue.async {
            if let imageData = try? Data(contentsOf: URL(string: url)!) {
                let image = UIImage(data: imageData);
                DispatchQueue.main.async(execute: {
                    callback(image);
                });
            }
        }
    }

}
