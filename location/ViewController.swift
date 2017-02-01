//
//  ViewController.swift
//  location
//
//  Created by DJuser on 11/7/2559 BE.
//  Copyright © 2559 DJuser. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate  {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var mylong: UITextField!
    @IBOutlet weak var mylat: UITextField!

    
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []
    
    var locManager: CLLocationManager!
    var currentLocation: CLLocation!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        currentLocation = CLLocation()
    
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
        }
        
        mylong.text = "\(currentLocation.coordinate.longitude)"
        mylat.text = "\(currentLocation.coordinate.latitude)"
        
        
        //Setup our Map View
        map.showsUserLocation = true
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

