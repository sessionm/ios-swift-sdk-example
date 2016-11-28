//
//  AchievementsTableViewController.swift
//  ios-swift-sdk-example
//
//  Copyright © 2016 SessionM. All rights reserved.
//

import UIKit

class AchievementsTableViewController: UITableViewController {

    var achievements : [SMAchievementData] = [];
    var inWorkAchievements : [SMAchievementData] = [];
    var claimableAchievements : [SMAchievementData] = [];

    override var prefersStatusBarHidden : Bool { return true; }

    override func viewWillAppear(_ animated: Bool) {
        achievements = SessionM.sharedInstance().user.achievements;
        claimableAchievements    = SessionM.sharedInstance().user.claimableAchievements;
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Claimable", "Possible"][section];
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [claimableAchievements.count, achievements.count][section];
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Achievement Cell", for: indexPath) as! AchievementsTableViewCell;

        let list = [ claimableAchievements, achievements][indexPath.section];
        let achieve = list[indexPath.row];

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
    func loadFromUrl(_ url : String, callback : @escaping ((UIImage?) -> Void)) {
        let queue = DispatchQueue.global(qos: .userInteractive);
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
