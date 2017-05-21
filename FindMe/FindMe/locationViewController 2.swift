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

class locationViewController: UIViewController, CLLocationManagerDelegate {

    //fileprivate var locations = [MKPointAnnotation]()  //duan12/03
    
    
    let rootRef = FIRDatabase.database().reference().child("locations")
    

    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var mylong: UITextField!
    @IBOutlet weak var mylat: UITextField!
    
    //var manager:CLLocationManager!
    //var myLocations: [CLLocation] = []
    
    var locManager: CLLocationManager!
    //var currentLocation: CLLocation!
    
    
    //recieve tag detail from TagsCollectionViewController
    var tagselectedimage = UIImage()
    var tagselecteddetail = [String:String]()
    //var tagselectedkey = String()
    var selectedtagdetailkey = String()
    
    
    //iBeacon
    // locationManager: CLLocationManager!
    var accuracy: CLLocationAccuracy!       //duan
    //var rssi: Int = 0
    var check : Int = 0
    //endiBeacon
    


    override func viewDidLoad() {
        super.viewDidLoad()
    
        //manager = CLLocationManager()
       // manager.desiredAccuracy = kCLLocationAccuracyBest
       //manager.requestAlwaysAuthorization()
    
        //declare location manager
        locManager = CLLocationManager()
        locManager.delegate = self
        //locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestAlwaysAuthorization()
        //locManager.startUpdatingLocation()

        
        //currentLocation = CLLocation()
        
        //iBeacon
        accuracy = CLLocationAccuracy()
        //endiBeacon
        

        /*
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            
            currentLocation = locManager.location
        }
         */
        //mylong.text = "current vd longitude: \(currentLocation.coordinate.longitude)"
        //mylat.text = "current vd latitude: \(currentLocation.coordinate.latitude)"
    
        //map.showsUserLocation = true
       
        openMapForPlace()
    
    }
    
    //iBeacon
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "2729ABCD-0102-0304-5C6D-7E8F00000001")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "MyiBeacon")
        
        locManager.startMonitoring(for: beaconRegion)
        locManager.startRangingBeacons(in: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
           // updateDistance(beacons[0].proximity)
            check = 1
        } else {
            //updateDistance(.unknown)
            check = 0
        }
    }
    
    /*
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
 */
    //endiBeacon

    
    //retrive data from firebase
    func openMapForPlace() {
        
        print("selected key location: \(selectedtagdetailkey)")
        
        FIRDatabase.database().reference().child("TagsDetail").child("\(selectedtagdetailkey)").observe(.value, with: { (snapshots) in
            
            //if1
            if let dic = snapshots.value as? [String: AnyObject] {
                var tagid = dic["tagid"] as! String?
                
                print("tag id : \(tagid!)")
                
                self.rootRef.child("\(tagid!)").observeSingleEvent(of: .value, with: { (snapshot) in
                    var latitudes: CLLocationDegrees
                    var longitudes: CLLocationDegrees
                    var initialLocation : CLLocation
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        
                        latitudes = (dictionary["latitude"] as! CLLocationDegrees?)!
                        longitudes = (dictionary["longitude"] as! CLLocationDegrees?)!
                        
                        initialLocation = CLLocation(latitude: latitudes, longitude: longitudes)
                        print("latitude : \(latitudes)")
                        print("longitudes  : \(longitudes )")
                        
                        self.mylong.text = "retrieve longitude: \(longitudes)"
                        self.mylat.text = "retrieve latitude: \(latitudes)"
                        
                        self.centerMapOnLocation(location: initialLocation)
                    }
                    
                }, withCancel: nil)

    
                
            }//end if1
            
        })

       
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        map.addAnnotation(annotation)
        
        //auto zoom in map
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
        
    }
    
    //send selected yag detail to show on tagdetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var dstVC : collectiontagdetailViewController = segue.destination as! collectiontagdetailViewController
        
        dstVC.detail = self.tagselecteddetail
        
        //dstVC.key = self.tagselectedkey // tagidไม่ตรงกับรูปเวลาขึ้น
        dstVC.tagdetailkey = self.selectedtagdetailkey //duan 11/03
       
    }

   
    @IBAction func edit(_ sender: Any) {
         self.performSegue(withIdentifier: "edittagdetail", sender: nil)
    }
   
    
    @IBAction func backdidtouch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}



