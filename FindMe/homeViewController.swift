//
//  homeViewController.swift
//  FindMe
//
//  Created by DJuser on 1/31/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//


//version 20/3/2017
import UIKit
import FirebaseAuth

import MapKit
import CoreLocation
import Firebase

class homeViewController: UIViewController,CLLocationManagerDelegate {
    //sent background locaation
    let rootRef = FIRDatabase.database().reference().child("locations")
    
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []
    var locManager: CLLocationManager!
    var currentLocation: CLLocation!
    //iBeacon
    var accuracy: CLLocationAccuracy!
    var check : Int = 0
    
    //set major minor variable
    let uuid = UUID(uuidString: "2729ABCD-0102-0304-5C6D-7E8F00000001")!
    var m = CLBeaconMajorValue()
    var n = CLBeaconMinorValue()
    
    var dicuuid = UUID()
    var dicmajor = CLBeaconMajorValue()
    var dicminor = CLBeaconMinorValue()
    //endiBeacon
    
    @IBOutlet var testtagkey: UILabel!
    
    var usertagkey : String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // //sent background locaation
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        
        locManager = CLLocationManager()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestAlwaysAuthorization()
        locManager.startUpdatingLocation()
        currentLocation = CLLocation()
        
        //iBeacon
        accuracy = CLLocationAccuracy()   //duan
        //endiBeacon
        
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLocation = locManager.location
        }
        //end sent background locaation
        
        /*ใช้ส่งโลเคชั่นไปเทสว่าดึงตำแหน่งoutdoorมาแสดงถูกมั้ย
         let location = [
         "tagkey": "-Kexo955kksBAZl546Y_",
         "latitude": 13.76483333,
         "longitude": 100.5382222,
         ] as [String : Any]
         //rootRef.child("\(usertagkey)").setValue(location)
         rootRef.child("-Kexo955kksBAZl546Y_").setValue(location)
         */
        
    }

    //iBeacon
    //(1)
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            
            m = CLBeaconMajorValue(beacons[0].major)
            n = CLBeaconMinorValue(beacons[0].minor)
            
            if let user = FIRAuth.auth()?.currentUser{
                
                FIRDatabase.database().reference().child("Tags").observe(.childAdded, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        var userid = dictionary["userid"] as! String?
                        
                        if userid! == user.uid {
                            self.dicmajor = dictionary["major"] as! CLBeaconMajorValue
                            self.dicminor = dictionary["minor"] as! CLBeaconMinorValue
                            
                            if self.dicmajor == self.m && self.dicminor == self.n {
                                self.usertagkey = snapshot.key
                                
                                self.testtagkey.text = "key : \(self.usertagkey) major: \(self.m) minor: \(self.n)"
                                
                            }
                            
                        }
                        
                    }
                    
                }, withCancel: nil)
            }
            
            updateDistance(beacons[0].proximity)
            
            check = 1
            
            
        } else {
            updateDistance(.unknown)
            check = 0
            
        }
    }
    
    func startScanning() {
        //let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: m, minor: n, identifier: "MyiBeacon")
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "MyiBeacon")
        
        locManager.startMonitoring(for: beaconRegion)
        locManager.startRangingBeacons(in: beaconRegion)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    
    func updateDistance(_ distance: CLProximity) {
        UIView.animate(withDuration: 0.5) {
            //withDuration คือ ความเร็วในการแสดงanimationสีว่าจะเปลี่ยนจากสีนึงเป็นอีกสีนึงเร็วแค่ไหน
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.black
                
            case .far:
                self.view.backgroundColor = UIColor.blue
                
            case .near:
                self.view.backgroundColor = UIColor.orange
                
            case .immediate:
                self.view.backgroundColor = UIColor.red
                
            }
        }
    }
    //endiBeacon
    
    //update location in background mode to firebase
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // shortcuts
        let value = manager.location?.coordinate
        let latitude = value?.latitude
        let longitude = value?.longitude
        
        // user location
        let center = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        
        let pin = CLLocationCoordinate2DMake(latitude!, longitude!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = pin
        print("tagkey firebase: \(usertagkey)")
        if UIApplication.shared.applicationState == .active {
            if check == 1 {
                
                let location = [
                    "tagkey": usertagkey,
                    "latitude": (latitude),
                    "longitude": (longitude),
                    ] as [String : Any]
                rootRef.child("\(usertagkey)").setValue(location)
                testtagkey.text = "active mode key : \(usertagkey)"
            }
            
        }else{
            if check == 1 {
                print("App is backgrounded. New location is %@",pin)
                let location = [
                    "tagkey": usertagkey,
                    "latitude": (latitude),
                    "longitude": (longitude),
                    ] as [String : Any]
                rootRef.child("\(usertagkey)").setValue(location)
                testtagkey.text = "background mode key : \(usertagkey)"
            }
        }
        
    }

    
    
    @IBAction func logoutdidtouch(_ sender: Any) {
        try! FIRAuth.auth()!.signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let logout = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate .window?.rootViewController = logout
      
    }
    
}



