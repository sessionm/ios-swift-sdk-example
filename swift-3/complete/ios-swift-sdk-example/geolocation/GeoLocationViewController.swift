//
//  GeoLocationViewController.swift
//  ios-swift-sdk-example
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

        let nCenter = NotificationCenter.default;

        // Issue
        nCenter.addObserver(self, selector:#selector(concern(_:)), name: NSNotification.Name(rawValue: disabledLocationServicesNotification), object: nil);
        nCenter.addObserver(self, selector:#selector(concern(_:)), name: NSNotification.Name(rawValue: regionMonitoringFailureNotification), object: nil);
        nCenter.addObserver(self, selector:#selector(concern(_:)), name: NSNotification.Name(rawValue: disabledAlwaysOnLocationServicesNotification), object: nil);

        // Success
        nCenter.addObserver(self, selector:#selector(locationChanged(_:)), name: NSNotification.Name(rawValue: locationUpdateNotification), object: nil);
        nCenter.addObserver(self, selector:#selector(newGeoLocations(_:)), name: NSNotification.Name(rawValue: updatedLocationEventsNotification), object: nil);
        nCenter.addObserver(self, selector:#selector(didTriggerLocation(_:)), name: NSNotification.Name(rawValue: triggeredLocationEventNotification), object: nil);
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        refreshUI();
    }

    @IBAction func activeToggle(_ sender: UIButton) {
        if (locationManager.isGeofenceServiceStarted) {
            locationManager.stopGeofenceService();
        } else {
            locationManager.startGeofenceService();
        }
        refreshUI();
    }

    func refreshUI() {
        activeToggleButton.setTitle(locationManager.isGeofenceServiceStarted ? "Stop Geo Location" : "Start Geo Location", for: UIControlState());
        if (!locationManager.isGeofenceServiceStarted) {
            clLocations = [];
            clRegions = [];
            tableView.reloadData();
            updateGeo("", lat: 0.0, lng: 0.0, radius: 0);
            updateLocation(0.0, lng: 0.0);
            locationCoordinates.text = "Not available";
        }
    }

    func updateGeo(_ evt : String, lat : Float, lng : Float, radius : Int) {
        event.text = evt;
        geoRadius.text = radius != 0 ? "\(radius)" : "";
        geoCoordinates.text = ((lat != 0.0) || (lng != 0.0)) ? "Coords: \(lat), \(lng)" : "Not Available";
    }

    func updateLocation(_ lat : Double, lng : Double) {
        locationCoordinates.text = ((lat != 0.0) || (lng != 0.0)) ? "Coords: \(lat), \(lng)" : "Not Available";
    }

    func locationChanged(_ notification : Notification) {
        if let location = locationManager.currentGeoLocation {
            updateLocation(location.coordinate.latitude, lng: location.coordinate.longitude);
        }
        refreshUI();
    }

    func concern(_ notification: Notification) {
        refreshUI();
    }

    func newGeoLocations(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            clRegions = userInfo[kMonitoredRegions] as! [CLCircularRegion];
            clLocations = userInfo[kLocationEvents] as! [SMLocationEvent];
        } else {
            clRegions = [];
            clLocations = [];
        }
        self.tableView.reloadData();
        refreshUI();
    }

    func didTriggerLocation(_ notification: Notification) {
        if let userInfo = notification.userInfo as! [String : AnyObject]? {
            if let e = userInfo["event"] as! String? {
                if let location = userInfo["location"] {
                    if let lat = location["latitude"] as! NSNumber?, let lng = location["longitude"] as! NSNumber? {
                        updateLocation(lat.doubleValue, lng: lng.doubleValue);
                    }
                }
                if let fence = userInfo["geofence"] {
                    if let lat = fence["latitude"] as! NSNumber?, let lng = fence["longitude"] as! NSNumber?, let radius = fence["radius"] as! NSNumber? {
                        updateGeo(e, lat: lat.floatValue, lng: lng.floatValue, radius: radius.intValue);
                    }
                }
            }
        }
        refreshUI();
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clLocations.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var location : SMLocationEvent?;
        let region = clRegions[indexPath.row];
        let pieces = region.identifier.characters.split(separator: "-").map(String.init);
        if (pieces.count > 1) {
            if let index = Int(pieces[1]) {
                location = clLocations[index];
            }
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "Location Cell", for: indexPath) as! LocationCell

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
