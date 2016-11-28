//
//  AchievementsTableViewController.swift
//  ios-swift-sdk-example
//
//  Copyright © 2016 SessionM. All rights reserved.
//

import UIKit

class AchievementsTableViewController: UITableViewController {

    var achievements = [];
    var inWorkAchievements = [];
    var claimableAchievements = [];

    override func prefersStatusBarHidden() -> Bool { return true; }

    override func viewWillAppear(animated: Bool) {
        achievements = SessionM.sharedInstance().user.achievements;
        claimableAchievements    = SessionM.sharedInstance().user.claimableAchievements;
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Claimable", "Possible"][section];
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [claimableAchievements.count, achievements.count][section];
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Achievement Cell", forIndexPath: indexPath) as! AchievementsTableViewCell;

        let list = [ claimableAchievements, achievements][indexPath.section];
        let achieve = list[indexPath.row] as! SMAchievementData;

        cell.nameLabel.text = achieve.name;
        cell.messageLabel.text = achieve.message;
        cell.actionLabel.text = !achieve.action.isEmpty ? achieve.action : "<no action>";
        cell.pointsLabel.text = "\(achieve.pointValue)";
        cell.limitLabel.text = "\(achieve.limitText)";
        if ((achieve.distance < 0) || (achieve.unclaimedCount < 0)) {
            cell.distanceLabel.text = "n/a";
            cell.claimableLabel.text = "n/a";
        } else {
            cell.distanceLabel.text = "\(achieve.distance)";
            cell.claimableLabel.text = "\(achieve.unclaimedCount)";
        }
        if let url = achieve.achievementIconURL {
            loadFromUrl(url) { (image : UIImage?) in
                if let i = image {
                    cell.iconImage.image = i;
                }
            }
        }

        return cell
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
