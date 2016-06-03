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
        self.enrollmentLabel.text = String(self.currentSchool.enrollment!)
        
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
    
//    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//        locationManager.stopUpdatingLocation()
//        if ((error) != nil) {
//            if (seenError == false) {
//                seenError = true
//                print(error, terminator: "")
//            }
//        }
//    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            
            print(coord.latitude)
            print(coord.longitude)
        }
    }
    
    func locationManager(manager: CLLocationManager,  didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
        case CLAuthorizationStatus.Restricted:
            locationStatus = "Restricted Access to location"
        case CLAuthorizationStatus.Denied:
            locationStatus = "User denied access to location"
        case CLAuthorizationStatus.NotDetermined:
            locationStatus = "Status not determined"
        default:
            locationStatus = "Allowed to location Access"
    
        }
        NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
    }
    
    // MARK: MapView
    
    
    func locateSchool() {
        var address: String
        address = self.createAddress()
//        var geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(address, completionHandler: {(placemarks: Optional<Array<CLPlacemark>>, Optinal< NSError>) -> ()
//            if let placemark = placemarks?[0] as? CLPlacemark {
//                
//                self.schoolCoords = placemark.location.coordinate
//                var pointAnnotation:MKPointAnnotation = MKPointAnnotation()
//                pointAnnotation.coordinate = self.schoolCoords
//                pointAnnotation.title = self.currentSchool.name
//                self.mapView?.addAnnotation(pointAnnotation)
////                self.mapView?.centerCoordinate = self.schoolCoords
//                self.mapView?.selectAnnotation(pointAnnotation, animated: true)
//                
//                self.centerMap()
//            }
//        })
    }
    
    func createAddress() -> String {
        let school = self.currentSchool
        let address = school.address["street"]!
//            school.address["city"] + " " +
//            school.address["state"] + " " +
//            school.address["zip"]
        
        return address
    }
    
    func centerMap() {
        var zoomRect = MKMapRectNull
        for annotation in self.mapView.annotations {
            let annotationPoint = MKMapPointForCoordinate(annotation.coordinate)
            let annotationRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1)
            zoomRect = MKMapRectUnion(zoomRect, annotationRect)
        }
        self.mapView.setVisibleMapRect(zoomRect, animated: true)
        
    }
    
    func mapView (mapView: MKMapView,
        viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
            if(annotation.isEqual(self.mapView.userLocation)) {
                return nil
            }
            let pinView:MKPinAnnotationView = MKPinAnnotationView()
            pinView.annotation = annotation
            pinView.pinColor = MKPinAnnotationColor.Green
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            let button = UIButton(type: UIButtonType.DetailDisclosure)
//            let button   = UIButton.buttonWithType(UIButtonType.System) as UIButton
//            button.frame = CGRectMake(100, 100, 100, 100)
//            button.setImage(image, forState: .Normal)
            button.addTarget(self, action: #selector(SchoolViewController.openMapForPlace(_:)), forControlEvents:.TouchUpInside)
            
            pinView.rightCalloutAccessoryView = button
            
            return pinView
    }
    
    func mapView(mapView: MKMapView,
        didSelectAnnotationView view: MKAnnotationView){

    }
    
    @IBAction func openMapForPlace(sender: AnyObject) {
      
        let regionDistance:CLLocationDistance = 10000

        let regionSpan = MKCoordinateRegionMakeWithDistance(self.schoolCoords, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: self.schoolCoords, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.currentSchool.name
        mapItem.openInMapsWithLaunchOptions(options)
    }

    // MARK: Phone
    
    @IBAction func callPhone(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + self.currentSchool.phoneNumber)!)
    }

}
