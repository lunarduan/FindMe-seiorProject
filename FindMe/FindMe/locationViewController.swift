//
//  locationViewController.swift
//  FindMe
//
//  Created by DJuser on 2/28/2560 BE.
//  Copyright © 2560 DJuser. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation
import Firebase

import CoreBluetooth

class locationViewController: UIViewController, CLLocationManagerDelegate,CBCentralManagerDelegate, CBPeripheralManagerDelegate, CBPeripheralDelegate {

    //let rootRef = FIRDatabase.database().reference().child("locations")
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var mylong: UITextField!
    @IBOutlet weak var mylat: UITextField!
    @IBOutlet weak var directionarrow: UIImageView!
    
    @IBOutlet weak var mydistance: UITextField!
    
    var locManager: CLLocationManager!
    
    //recieve tag detail from TagsCollectionViewController
    var tagselectedimage = UIImage()
    var tagselecteddetail = [String:String]()
    var selectedtagdetailkey = String()
    
    //iBeacon
    // locationManager: CLLocationManager!
    var accuracy: CLLocationAccuracy!
    var rssi: Int = 0
    var check : Int = 0
    
    var lm:CLLocationManager!
    
    var freqarray : [Double] = []
    var degreearray : [Double] = []
    var maxfreq : Double = -300.00
    var maxdegree : Double = 0.0
    
    var mydict = Dictionary<Double,Double>()
    var result : Double = 0.0
    //let uuid = UUID(uuidString: "2729ABCD-0102-0304-5C6D-7E8F00000001")!
    let uuid = UUID(uuidString: "74278bda-b644-4520-8f0c-720eaf059935")!
    
    var cManager = CBCentralManager()
    var peripheralManager = CBPeripheralManager()
    var discoveredPeripheral:CBPeripheral?
    
    var m = CLBeaconMajorValue()
    var n = CLBeaconMinorValue()
    var dicmajor = CLBeaconMajorValue()
    var dicminor = CLBeaconMinorValue()
    var tagid: String = ""
    var latitudes = CLLocationDegrees()
    var longitudes = CLLocationDegrees()
    
    var annotations : [MKPointAnnotation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //manager = CLLocationManager()
        // manager.desiredAccuracy = kCLLocationAccuracyBest
        //manager.requestAlwaysAuthorization()
        
        //declare location manager
        locManager = CLLocationManager()
        locManager.delegate = self
        locManager.requestAlwaysAuthorization()
        
        //locManager.desiredAccuracy = kCLLocationAccuracyBest
        //locManager.startUpdatingLocation()
        //currentLocation = CLLocation()
        
        
        //iBeacon
        accuracy = CLLocationAccuracy()

        //indoor update heading of phone
        lm = CLLocationManager()
        lm.delegate = self
        lm.startUpdatingHeading()
        lm.startUpdatingLocation()
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        openMapForPlace()
    
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager!) {
    }
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
    }

    
    //iBeacon
    func startScanning() {
   
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
    
   
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {

        if beacons.count > 0 {
            
             for var i in 0..<beacons.count {
                
                FIRDatabase.database().reference().child("TagsDetail").child("\(selectedtagdetailkey)").observeSingleEvent(of: .value, with: { (snapshot) in

                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        
                        self.tagid  = (dictionary["tagid"] as! String?)!
                      

                        FIRDatabase.database().reference().child("Tags").child("\(self.tagid)").observe(.value, with: { (snap) in
                            
                            if let dict = snap.value as? [String: AnyObject]{
                                
                                var major = (dict["major"]) as! String?
                                var minor = (dict["minor"]) as! String?
                                
                                var intmajor = UInt16(major!)
                                var intminor = UInt16(minor!)
                                self.dicmajor = intmajor! as CLBeaconMajorValue
                                self.dicminor = intminor! as CLBeaconMinorValue
                                
                                let beaconRegion = CLBeaconRegion(proximityUUID: self.uuid, major: self.dicmajor, minor:  self.dicminor, identifier: "MyiBeacon")
                                
                                self.locManager.startMonitoring(for: beaconRegion)
                                self.locManager.startRangingBeacons(in: beaconRegion)
                                
                                //self.updateDistance(beacons[i].proximity)
                                self.mydistance.text = "Distance(m): " + String(beacons[i].accuracy)
                                self.freqarray.append((Double(beacons[i].rssi)))
                                self.check = 1
                            
                            }
                            
                        })
                        //self.scan()

                    }
                
                }, withCancel: nil)

            }

            
        } else {
            check = 0
        }
    }

    
    
    //show degree of mobile direction
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        var degree = newHeading.magneticHeading
        let trueheading = newHeading.trueHeading
        
        if trueheading >= 0 {
            degree = trueheading
        }
        
        let cards = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        var dir = "N"
        
        for (ix, card) in cards.enumerated() {
            if degree < 45.0/2.0 + 45.0*Double(ix) {
                dir = card
                break
            }
        }
        
        degreearray.append(degree)
        
        if freqarray != []  {
            var index: Double = freqarray[0]
            if index.isEqual(to: 0.0){
                freqarray.remove(at: 0)
            }
        }
        
        mydict[degree] = freqarray.last

        let start = degreearray[0]
    
        for (key, val) in mydict{
            if val > maxfreq {
                maxfreq = val
                
                let diff = key - start
                
                if diff < 0{
                    result = 360 - (diff*(-1))
                }
                else{
                    result = diff
                }
                
                //show animation along with degree
                UIView.animate(withDuration: 0.6, animations: {
                    self.directionarrow.transform = CGAffineTransform(rotationAngle: CGFloat(self.result  * M_PI/180))
                })
                
            }
        }
        
        
    }

    
    
    @IBAction func startdirection(_ sender: Any) {
        
        maxfreq = -300.00
        maxdegree = 0.0
        result = 0.0
        degreearray.removeAll()
        freqarray.removeAll()
        mydict.removeAll()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.directionarrow.transform = CGAffineTransform(rotationAngle: CGFloat(self.result  * M_PI/180))
        })
        
    }
    
    
    
    func updateDistance(_ distance: CLProximity) {
        UIView.animate(withDuration: 0.5) {
            
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.lightGray
                
            case .far:
                self.view.backgroundColor = UIColor.blue
                
            case .near:
                self.view.backgroundColor = UIColor.orange
                
            case .immediate:
                self.view.backgroundColor = UIColor.red
                
            }
        }
    }

    
    //retrive data from firebase
    func openMapForPlace() {
        
        FIRDatabase.database().reference().child("TagsDetail").child("\(selectedtagdetailkey)").observe(.value, with: { (snapshots) in
            
            if let dic = snapshots.value as? [String: AnyObject] {
                
                var id = dic["tagid"] as! String?
                self.fetchLocation(idkey: id!)
            }
            
        })
        
    }
    
    func fetchLocation(idkey:String){
        
        FIRDatabase.database().reference().child("locations").child("\(idkey)").observe(.value, with: { (snapshot) in
            let dictionary = snapshot.value as? [String: AnyObject]
            
            if dictionary?["latitude"] == nil && dictionary?["longitude"] == nil{
                self.latitudes = 0.0
                self.longitudes = 0.0
            
            }else{
                self.latitudes = (dictionary?["latitude"] as! CLLocationDegrees?)!
                self.longitudes = (dictionary?["longitude"] as! CLLocationDegrees?)!
                
            }
           
            //let latitudes = (dictionary?["latitude"] as! CLLocationDegrees?)!
            //let longitudes = (dictionary?["longitude"] as! CLLocationDegrees?)!

            let initialLocation = CLLocation(latitude: self.latitudes, longitude: self.longitudes)
            
            if self.longitudes != 0.0 && self.latitudes != 0.0{
                self.mylong.text = "Recieve longitude: \(self.longitudes)"
                self.mylat.text = "Recieve latitude: \(self.latitudes)"
            }else{
                self.mylong.text = "This tag not exist"
                self.mylat.text = "This tag not exist"
            }
            
            self.centerMapOnLocation(location: initialLocation)
        })
        
         /*
        //self.rootRef.child("\(idkey)").observeSingleEvent(of: .value, with: { (snapshot) in
            var latitudes: CLLocationDegrees
            var longitudes: CLLocationDegrees
            var initialLocation : CLLocation
            
        
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                latitudes = (dictionary["latitude"] as! CLLocationDegrees?)!
                longitudes = (dictionary["longitude"] as! CLLocationDegrees?)!
        
                initialLocation = CLLocation(latitude: latitudes, longitude: longitudes)
                
                self.mylong.text = "Recieve longitude: \(longitudes)"
                self.mylat.text = "Recieve latitude: \(latitudes)"
                
                self.centerMapOnLocation(location: initialLocation)
            }
            
        }, withCancel: nil)
         */
        
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        //map.addAnnotation(annotation)
        annotations.append(annotation)
        map.removeAnnotations(annotations)
        map.addAnnotation(annotations.last!)
       
        
        //auto zoom in map
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
        
    }
    
    //send selected yag detail to show on tagdetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var dstVC : collectiontagdetailViewController = segue.destination as! collectiontagdetailViewController
        dstVC.detail = self.tagselecteddetail
        dstVC.tagdetailkey = self.selectedtagdetailkey
    }
    
   
    @IBAction func editdidtouch(_ sender: Any) {
        self.performSegue(withIdentifier: "edittagdetail", sender: nil)
    }
    
    @IBAction func backdidtouch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}



