//
//  homeViewController.swift
//  FindMe
//
//  Created by DJuser on 1/31/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//

import UIKit
import FirebaseAuth

import MapKit
import CoreLocation
import Firebase

import UserNotifications

class homeViewController: UIViewController,CLLocationManagerDelegate {

    let rootRef = FIRDatabase.database().reference().child("locations")
    
    var tagidKeyConstant = ""
    var tagnameKeyConstant = ""
    var tagdescriptionKeyConstant = ""
    var tagnotidistanceKeyConstant = ""
    var notiswitchKeyConstant = ""
    
    //var recievenotiswitchstate : Bool = false
    //var recievenotidistance : String = ""
    //var recievename : String = ""

    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []
    var locManager: CLLocationManager!
    var currentLocation: CLLocation!
 
    var accuracy: CLLocationAccuracy!
    var check : Int = 0

    //let uuid = UUID(uuidString: "2729ABCD-0102-0304-5C6D-7E8F00000001")!
    let uuid = UUID(uuidString: "74278bda-b644-4520-8f0c-720eaf059935")!
    
    var m = CLBeaconMajorValue()
    var n = CLBeaconMinorValue()

    var dicmajor = CLBeaconMajorValue()
    var dicminor = CLBeaconMinorValue()

    
    var usertagkey : [String] = []
    var count = 2
    
    @IBOutlet weak var webViewtutorial: UIWebView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: {didAllow, error in
        })
    
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        
        locManager = CLLocationManager()
        locManager.delegate = self
        
        locManager.pausesLocationUpdatesAutomatically = false
        locManager.allowsBackgroundLocationUpdates = true
        
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestAlwaysAuthorization()
        locManager.startUpdatingLocation()
        currentLocation = CLLocation()
        
        accuracy = CLLocationAccuracy()
        
        
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLocation = locManager.location
        }
        
    
      
        let htmlPath = Bundle.main.path(forResource: "tutorial", ofType: "html")
        let htmlURL = URL(fileURLWithPath: htmlPath!)
        let html = try? Data(contentsOf: htmlURL)
        
        self.webViewtutorial.load(html!, mimeType: "text/html", textEncodingName: "UTF-8", baseURL: htmlURL.deletingLastPathComponent())
    
    }

    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }


    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {

        if UIApplication.shared.applicationState == .active {
          
            if beacons.count > 0 {
                
                self.updateDistance(beacons[0].proximity)
                count = beacons.count
                
                for var i in 0..<beacons.count {
                
                        if #available(iOS 10.0, *) {
                            Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { (time) in
                            
                                let beaconRegion = CLBeaconRegion(proximityUUID: self.uuid, major: CLBeaconMajorValue(beacons[i].major), minor:  CLBeaconMinorValue(beacons[i].minor), identifier: "MyiBeacon")
                            
                                if(self.count > 0) {
                                    if let user = FIRAuth.auth()?.currentUser{

                                        FIRDatabase.database().reference().child("Tags").observe(.childAdded, with: { (snapshot) in
                                        
                                            self.locManager.startMonitoring(for: beaconRegion)
                                            self.locManager.startRangingBeacons(in: beaconRegion)
                                        
                                            self.m = CLBeaconMajorValue(beacons[i].major)
                                            self.n = CLBeaconMinorValue(beacons[i].minor)
                                            
                                            
                                            if let dictionary = snapshot.value as? [String: AnyObject] {
                                                var userid = dictionary["userid"] as! String?
                                                var major = (dictionary["major"]) as! String?
                                                var minor = (dictionary["minor"]) as! String?
                                                
                                                var intmajor = UInt16(major!)
                                                var intminor = UInt16(minor!)
        
                                                self.dicmajor = intmajor! as CLBeaconMajorValue
                                                self.dicminor = intminor! as CLBeaconMinorValue
                                                
                                                if self.dicmajor == self.m && self.dicminor == self.n {
                                                    self.usertagkey.append(snapshot.key)
                                                    
                                                    if userid == user.uid {
                                                        
                                                        self.tagidKeyConstant = snapshot.key
                                                        
                                                        self.tagnameKeyConstant = "\(self.tagidKeyConstant)"+"tagnameKey"
                                                        self.tagdescriptionKeyConstant = "\(self.tagidKeyConstant)"+"tagdescriptionKey"
                                                        self.tagnotidistanceKeyConstant = "\(self.tagidKeyConstant)"+"tagnotidistanceKey"
                                                        self.notiswitchKeyConstant = "\(self.tagidKeyConstant)"+"notiswitchKey"
                                                    
                                                        //self.readData()
                                                        
                                                        let defaults = UserDefaults.standard
                                                        let name = defaults.string(forKey:self.tagnameKeyConstant)
                                                        let notidistance = defaults.string(forKey:self.tagnotidistanceKeyConstant)
                                                        let notiswitchstate = defaults.bool(forKey:self.notiswitchKeyConstant)
                                                        
                                                        let recievename = name
                                                        let recievenotidistance = notidistance
                                                        let recievenotiswitchstate = notiswitchstate

                                                        
                                                        let content = UNMutableNotificationContent()
                                                        content.title = "Findme notification Reminder"
                                                        content.body = "Your \(recievename!) is over on your phone's range!"
                                                        content.sound = UNNotificationSound.default()
                                                        //content.badge = 1

                                                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                                                        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
 
                                                    
                                                        if recievenotiswitchstate == true {
                                                            
                                                            if recievenotidistance == "Immediate(0 - 20 cm.)"
                                                            {
                                                                if beacons[i].accuracy >= 0.18
                                                                {
                                                                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                                                                }
                                                            
                                                            }
                                                        
                                                            if recievenotidistance == "Near(20 cm. - 2 m.)"
                                                            {
                                                                if beacons[i].accuracy >= 1.90
                                                                {
                                                                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                                                                }
                                                            
                                                            }
                                                            
                                                            if recievenotidistance == "Far(2 - 30 m.)"
                                                            {
                                                                if beacons[i].accuracy >= 29.00
                                                                {
                                                                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                                                                }
                                                            
                                                            }
                                                        
                                                        }else{ }

                                                    }
                                                
                                                }
                                            
                                            }
                                        
                                        }, withCancel: nil)
                                    }
                            
                                    self.count -= 1
                                }
                                else{
                                    if beacons.count > 1{
                                        
                                        self.locManager.stopRangingBeacons(in: beaconRegion) //24/03/2017
                                    }
                                }

                            }
                        } else {
                            // Fallback on earlier versions
                        }
                }
                
                check = 1
                
            } else {
                
                check = 0
            }
        }
        
    
        else{
            
            if beacons.count > 0 {
                
                count = beacons.count
               
                for var i in 0..<beacons.count {

                    if #available(iOS 10.0, *) {
                        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { (time) in
                            
                            let beaconRegion = CLBeaconRegion(proximityUUID: self.uuid, major: CLBeaconMajorValue(beacons[i].major), minor:  CLBeaconMinorValue(beacons[i].minor), identifier: "MyiBeacon")
                            
                            if(self.count > 0) {
                                
                                if let user = FIRAuth.auth()?.currentUser{
                                    
                                    FIRDatabase.database().reference().child("Tags").observe(.childAdded, with: { (snapshot) in
                                        
                                        self.locManager.startMonitoring(for: beaconRegion)
                                        self.locManager.startRangingBeacons(in: beaconRegion)
                                        
                                        self.m = CLBeaconMajorValue(beacons[i].major)
                                        self.n = CLBeaconMinorValue(beacons[i].minor)
                                        
                                        if let dictionary = snapshot.value as? [String: AnyObject] {
                                            var userid = dictionary["userid"] as! String?
                                            var major = (dictionary["major"]) as! String?
                                            var minor = (dictionary["minor"]) as! String?
                                            
                                            var intmajor = UInt16(major!)
                                            var intminor = UInt16(minor!)

                                            self.dicmajor = intmajor! as CLBeaconMajorValue
                                            self.dicminor = intminor! as CLBeaconMinorValue
                                            
                                            
                                            if self.dicmajor == self.m && self.dicminor == self.n {
                                                self.usertagkey.append(snapshot.key)
                                                
                                                if userid == user.uid {
                                                    
                                                    self.tagidKeyConstant = snapshot.key
                                                
                                                    self.tagnameKeyConstant = "\(self.tagidKeyConstant)"+"tagnameKey"
                                                    self.tagdescriptionKeyConstant = "\(self.tagidKeyConstant)"+"tagdescriptionKey"
                                                    self.tagnotidistanceKeyConstant = "\(self.tagidKeyConstant)"+"tagnotidistanceKey"
                                                    self.notiswitchKeyConstant = "\(self.tagidKeyConstant)"+"notiswitchKey"
                                                    
                                                    //self.readData()
                                                    let defaults = UserDefaults.standard
                                                    let name = defaults.string(forKey:self.tagnameKeyConstant)
                                                    let notidistance = defaults.string(forKey:self.tagnotidistanceKeyConstant)
                                                    let notiswitchstate = defaults.bool(forKey:self.notiswitchKeyConstant)
    
                                                    let recievename = name
                                                    let recievenotidistance = notidistance
                                                    let recievenotiswitchstate = notiswitchstate
                                                    

                                                    let content = UNMutableNotificationContent()
                                                    content.title = "Findme notification Reminder"
                                                    content.body = "Your \(recievename!) is over on your phone's range!"
                                                    content.sound = UNNotificationSound.default()
                                                    //content.badge = 1

                                                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                                                    let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
                                                    
                                                  
                                                    
                                                    if recievenotiswitchstate == true {
                                                        
                                                        if recievenotidistance == "Immediate(0 - 20 cm.)"
                                                        {
                                                            if beacons[i].accuracy >= 0.18
                                                            {
                                                                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                                                            }
                                                            
                                                        }
                                                        
                                                        if recievenotidistance == "Near(20 cm. - 2 m.)"
                                                        {
                                                            
                                                            if beacons[i].accuracy >= 1.90
                                                            {
                                                                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                                                            }
                                                            
                                                        }
                                                        if recievenotidistance == "Far(2 - 30 m.)"
                                                        {
                                                            if beacons[i].accuracy >= 29.00
                                                            {
                                                                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                                                            }
                                                            
                                                        }
                                                        
                                                    }else{}
                                                
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }, withCancel: nil)
                                }
                              
                                self.count -= 1
                                
                            }
                            else{
                                if beacons.count > 1{
                                    self.locManager.stopRangingBeacons(in: beaconRegion) //24/03/2017
                                }
                            }
                            
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                }
                check = 1
            } else {
                check = 0
            }

        }
    }

    
    
    func startScanning() {
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "MyiBeacon")
        
        beaconRegion.notifyEntryStateOnDisplay = true
        
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
    
    
    
    //update location in background mode to firebase
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
        let value = manager.location?.coordinate
        let latitude = value?.latitude
        let longitude = value?.longitude
        
        let center = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        
        let pin = CLLocationCoordinate2DMake(latitude!, longitude!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = pin
        
        for var j in 0..<usertagkey.count{

            var tagkey = usertagkey[j]
            
            if UIApplication.shared.applicationState == .active {
                if check == 1 {
                    let location = [
                        "tagkey": tagkey,
                        "latitude": (latitude),
                        "longitude": (longitude),
                        ] as [String : Any]
                    rootRef.child("\(tagkey)").setValue(location)
                }
            
            }else{
                if check == 1 {
                    
                    let location = [
                        "tagkey": tagkey,
                        "latitude": (latitude),
                        "longitude": (longitude),
                        ] as [String : Any]
                    
                    rootRef.child("\(tagkey)").updateChildValues(location)
                }
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
    
/*
    func readData(){
        
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey:tagnameKeyConstant)
        let notidistance = defaults.string(forKey:tagnotidistanceKeyConstant)
        let notiswitchstate = defaults.bool(forKey:notiswitchKeyConstant)

        recievename = name!
        recievenotidistance = notidistance!
        recievenotiswitchstate = notiswitchstate

    }
*/
    
}



