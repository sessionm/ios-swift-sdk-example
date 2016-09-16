//
//  GeoLocationViewController.swift
//  sdk-ios-sample
//
//  Copyright © 2016 SessionM. All rights reserved.
//

//
// Important Note
//
// Either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription must be in your
// info.plist file for GeoLocation to work.
//
// Recommended: NSLocationAlwaysUsageDescription -- Use this to always watch for GeoLocation events (While in foreground and background)
//              NSLocationWhenInUseUsageDescription -- Used only when App is active.
//


import UIKit

class GeoLocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var activeToggleButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var event: UILabel!
    @IBOutlet weak var geoCoordinates: UILabel!
    @IBOutlet weak var geoRadius: UILabel!

    @IBOutlet weak var locationCoordinates: UILabel!


    let locationManager = SMLocationManager.sharedInstance();

    var clRegions : [CLCircularRegion] = [];
    var clLocations : [SMLocationEvent] = [];


    override func viewDidLoad() {
        super.viewDidLoad();

        let nCenter = NSNotificationCenter.defaultCenter();

        // Issue
        nCenter.addObserver(self, selector:#selector(concern(_:)), name: SMLocationManagerLocationServicesDisabled, object: nil);
        nCenter.addObserver(self, selector:#selector(concern(_:)), name: SMLocationManagerMonitorRegionsDidFailWithErrorNotification, object: nil);
        nCenter.addObserver(self, selector:#selector(concern(_:)), name: SMLocationManagerAlwaysOnLocationServicesDisabled, object: nil);

        // Success
        nCenter.addObserver(self, selector:#selector(locationChanged(_:)), name: SMLocationManagerUpdateNotification, object: nil);
        nCenter.addObserver(self, selector:#selector(newGeoLocations(_:)), name: SMLocationManagerDidUpdateGeoLocations, object: nil);
        nCenter.addObserver(self, selector:#selector(didTriggerLocation(_:)), name: SMLocationManagerDidTriggerLocation, object: nil);
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        refreshUI();
    }

    @IBAction func activeToggle(sender: UIButton) {
        if (locationManager.isGeofenceServiceStarted) {
            locationManager.stopGeofenceService();
        } else {
            locationManager.startGeofenceService();
        }
        refreshUI();
    }

    func refreshUI() {
        activeToggleButton.setTitle(locationManager.isGeofenceServiceStarted ? "Stop Geo Location" : "Start Geo Location", forState: .Normal);
        if (!locationManager.isGeofenceServiceStarted) {
            clLocations = [];
            clRegions = [];
            tableView.reloadData();
            updateGeo("", lat: 0.0, lng: 0.0, radius: 0);
            updateLocation(0.0, lng: 0.0);
            locationCoordinates.text = "Not available";
        }
    }

    func updateGeo(evt : String, lat : Float, lng : Float, radius : Int) {
        event.text = evt;
        geoRadius.text = radius != 0 ? "\(radius)" : "";
        geoCoordinates.text = ((lat != 0.0) || (lng != 0.0)) ? "Coords: \(lat), \(lng)" : "Not Available";
    }

    func updateLocation(lat : Double, lng : Double) {
        locationCoordinates.text = ((lat != 0.0) || (lng != 0.0)) ? "Coords: \(lat), \(lng)" : "Not Available";
    }

    func locationChanged(notification : NSNotification) {
        if let location = locationManager.currentGeoLocation {
            updateLocation(location.coordinate.latitude, lng: location.coordinate.longitude);
        }
        refreshUI();
    }

    func concern(notification: NSNotification) {
        refreshUI();
    }

    func newGeoLocations(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            clRegions = userInfo[kSMLocationManagerRegionsKey] as! [CLCircularRegion];
            clLocations = userInfo[kSMLocationManagerLocationsKey] as! [SMLocationEvent];
        } else {
            clRegions = [];
            clLocations = [];
        }
        self.tableView.reloadData();
        refreshUI();
    }

    func didTriggerLocation(notification: NSNotification) {
        if let userInfo = notification.userInfo as! [String : AnyObject]? {
            if let e = userInfo["event"] as! String? {
                if let location = userInfo["location"] {
                    if let lat = location["latitude"] as! NSNumber?, lng = location["longitude"] as! NSNumber? {
                        updateLocation(lat.doubleValue, lng: lng.doubleValue);
                    }
                }
                if let fence = userInfo["geofence"] {
                    if let lat = fence["latitude"] as! NSNumber?, lng = fence["longitude"] as! NSNumber?, radius = fence["radius"] as! NSNumber? {
                        updateGeo(e, lat: lat.floatValue, lng: lng.floatValue, radius: radius.integerValue);
                    }
                }
            }
        }
        refreshUI();
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clLocations.count;
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var location : SMLocationEvent?;
        let region = clRegions[indexPath.row];
        let pieces = region.identifier.characters.split("-").map(String.init);
        if (pieces.count > 1) {
            if let index = Int(pieces[1]) {
                location = clLocations[index];
            }
        }

        let cell = tableView.dequeueReusableCellWithIdentifier("Location Cell", forIndexPath: indexPath) as! LocationCell

        if let local = location {
            cell.event.text = "Event: \(local.eventName)";
            cell.coordinates.text = "Location: \(local.latitude), \(local.longitude) (\(local.radius)m)";
        }
        
        return cell
    }

}

class LocationCell : UITableViewCell {

    @IBOutlet weak var event: UILabel!
    @IBOutlet weak var coordinates: UILabel!
}
