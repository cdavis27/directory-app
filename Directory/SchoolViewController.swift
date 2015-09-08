//
//  SchoolViewController.swift
//  Directory
//
//  Created by Candice on 5/27/15.
//  Copyright (c) 2015 cdavis27. All rights reserved.
//

import UIKit
import MapKit
import AddressBook
import CoreLocation

class SchoolViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var currentSchool: School!
    var schoolCoords: CLLocationCoordinate2D!
    var regionRadius: CLLocationDistance = 1000
    var lastLocation = CLLocation()
    var locationAuthorizationStatus:CLAuthorizationStatus!
    var window: UIWindow?
    var locationManager: CLLocationManager!
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : NSString = "Not Started"
    var coords: CLLocationCoordinate2D?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var enrollmentLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.currentSchool.name
        self.initLocationManager()
        self.addressLabel.text = self.createAddress()
        self.phoneButton.setTitle(self.currentSchool.phoneNumber, forState: UIControlState.Normal)
        self.enrollmentLabel.text = toString(self.currentSchool.enrollment!)
        
        createContactViews()
        self.scrollView.contentSize = view.frame.size
        
        locateSchool()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createContactViews() {
        var ypos = 319
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
    
    
    func locateSchool() {
        var address: String
        address = self.createAddress()
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                
                self.schoolCoords = placemark.location.coordinate
                var pointAnnotation:MKPointAnnotation = MKPointAnnotation()
                pointAnnotation.coordinate = self.schoolCoords
                pointAnnotation.title = self.currentSchool.name
                self.mapView?.addAnnotation(pointAnnotation)
//                self.mapView?.centerCoordinate = self.schoolCoords
                self.mapView?.selectAnnotation(pointAnnotation, animated: true)
                
                self.centerMap()
            }
        })
    }
    
    func createAddress() -> String {
        var school = self.currentSchool
        var address = school.address["street"]!
//            school.address["city"] + " " +
//            school.address["state"] + " " +
//            school.address["zip"]
        
        return address
    }
    
    func centerMap() {
        var zoomRect = MKMapRectNull
        for annotation in self.mapView.annotations as! [MKAnnotation] {
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
            let annotationRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1)
            zoomRect = MKMapRectUnion(zoomRect, annotationRect)
        }
        self.mapView.setVisibleMapRect(zoomRect, animated: true)
        
    }
    
    func mapView (mapView: MKMapView!,
        viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
            if(annotation.isEqual(self.mapView.userLocation)) {
                return nil
            }
            var pinView:MKPinAnnotationView = MKPinAnnotationView()
            pinView.annotation = annotation
            pinView.pinColor = MKPinAnnotationColor.Green
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            let button = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
//            let button   = UIButton.buttonWithType(UIButtonType.System) as UIButton
//            button.frame = CGRectMake(100, 100, 100, 100)
//            button.setImage(image, forState: .Normal)
            button.addTarget(self, action: "openMapForPlace:", forControlEvents:.TouchUpInside)
            
            pinView.rightCalloutAccessoryView = button
            
            return pinView
    }
    
    func mapView(mapView: MKMapView!,
        didSelectAnnotationView view: MKAnnotationView!){

    }
    
    @IBAction func openMapForPlace(sender: AnyObject) {
      
        let regionDistance:CLLocationDistance = 10000

        let regionSpan = MKCoordinateRegionMakeWithDistance(self.schoolCoords, regionDistance, regionDistance)
        var options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        var placemark = MKPlacemark(coordinate: self.schoolCoords, addressDictionary: nil)
        var mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.currentSchool.name
        mapItem.openInMapsWithLaunchOptions(options)
    }

    // MARK: Phone
    
    @IBAction func callPhone(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + self.currentSchool.phoneNumber)!)
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

}
