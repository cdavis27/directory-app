//
//  SchoolViewController.swift
//  Directory
//
//  Created by Candice on 5/27/15.
//  Copyright (c) 2015 cdavis27. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SchoolViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var currentSchool: School!
    var regionRadius: CLLocationDistance = 1000
    var lastLocation = CLLocation()
    var locationAuthorizationStatus:CLAuthorizationStatus!
    var window: UIWindow?
    var locationManager: CLLocationManager!
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    var coords: CLLocationCoordinate2D?
    
    // @IBOutlet var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var enrollmentLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.currentSchool.name
        self.initLocationManager()
        // centers map on users location, need to change to show users location and school location
//        centerMapOnLocation(locationManager.location)
        
        // sets up labels and contactViews
        self.addressLabel.text = self.currentSchool.address
        self.phoneLabel.text = self.currentSchool.phoneNumber
        self.enrollmentLabel.text = toString(self.currentSchool.enrollment!)
        createContactViews()
        
        locateSchool()

        self.scrollView.contentSize = view.frame.size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createContactViews() {
        var ypos = 370
        for contact in self.currentSchool.contacts {
            let contactView = ContactView(contact: contact, ypos: ypos)
            self.scrollView.addSubview(contactView)
            ypos += 88
        }
    }
    
    // Mark: Location Manager
    
    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            if (seenError == false) {
                seenError = true
                print(error)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            var locationArray = locations as NSArray
            var locationObj = locationArray.lastObject as! CLLocation
            var coord = locationObj.coordinate
            
            println(coord.latitude)
            println(coord.longitude)
        }
    }
    
    func locationManager(manager: CLLocationManager!,  didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
        case CLAuthorizationStatus.Restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.Denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.NotDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
    }
    
    // MARK: MapView
    
    func centerMapOnLocation(location: CLLocation) {
//        var zoomRect = MKMapRectNull
//        var myLocationPointRect = MKMapRectMake(myLocation.longitude, myLocation.latitude, 0, 0)
//        var currentDestinationPointRect = MKMapRectMake(currentDestination.longitude, currentDestination.latitude, 0, 0)
//        
//        zoomRect = myLocationPointRect
//        zoomRect = MKMapRectUnion(zoomRect, currentDestinationPointRect)
//        
//        self.mapView.setVisibleMapRect(zoomRect,true)
//        
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
//            regionRadius * 2.0, regionRadius * 2.0)
//        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locateSchool() {
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(self.currentSchool.address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
            }
        })
    }

    // MARK: TableView
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//        
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//        
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
//        if(indexPath.row == 0) {
//            cell.textLabel?.text = self.currentSchool.address;
//        } else if(indexPath.row == 1) {
//            cell.textLabel?.text = self.currentSchool.phoneNumber;
//        } else if(indexPath.row == 2) {
//            cell.textLabel?.text = toString(self.currentSchool.enrollment!);
//        }
//        return cell
//    }
//        
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
