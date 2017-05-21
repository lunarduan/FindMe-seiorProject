//
//  ViewController.swift
//  monitoring
//
//  Created by DJuser on 10/19/2559 BE.
//  Copyright © 2559 DJuser. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var mydistance: UITextField!
    @IBOutlet weak var myrssi: UITextField!
    @IBOutlet weak var mydirection: UITextField!
    @IBOutlet weak var directionarrow: UIImageView!
    
    var locationManager: CLLocationManager!
    var accuracy: CLLocationAccuracy!       //duan
    var rssi: Int = 0

    var lm:CLLocationManager!
    var current: CLLocationDirection!
    
    
    //direction
    @IBOutlet weak var val: UILabel!
    @IBOutlet weak var degreeval: UILabel!
    var freqarray : [Double] = []
    var degreearray : [Double] = []
    var maxfreq : Double = 0.0
    var maxdegree : Double = 0.0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        accuracy = CLLocationAccuracy()   //duan
        
        //config for compass direction degree
        lm = CLLocationManager()
        lm.delegate = self
        lm.startUpdatingHeading()
        lm.startUpdatingLocation()
        
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
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
            updateDistance(beacons[0].proximity)
        } else {
            updateDistance(.unknown)
        }
        self.mydistance.text = "Distance(m): " + String(beacons[0].accuracy)
        self.myrssi.text = "rssi frequency: " + String(beacons[0].rssi)
        
        //direction
        freqarray.append((Double(beacons[0].rssi)))
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
    
    
    //show degree of mobile direction
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        var degree = newHeading.magneticHeading
        let k = newHeading.trueHeading
        
        if k >= 0 {
            degree = k
        }
        
        let cards = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        var dir = "N"
        
        for (ix, card) in cards.enumerated() {
            if degree < 45.0/2.0 + 45.0*Double(ix) {
                dir = card
                break
            }
        }
    
        mydirection.text = "degree: \(degree) \(dir)"
       
        
        //direction
        degreearray.append(degree)
        
        let lastElementOfdegree = degreearray.last
        let lastElmentOffreq = freqarray.last
        val.text = "\(lastElmentOffreq!)"
        degreeval.text = "\(lastElementOfdegree!)"
        
        
        for i in 0...freqarray.count{
            maxfreq = freqarray.max()!
            //maxdegree = degreearray.max()!
            let indexofmaxfreq = freqarray.index(of: maxfreq)
            let degreevalueAtmaxfreq = degreearray[indexofmaxfreq!]
           
            //show animation along with degree
            UIView.animate(withDuration: 0.6, animations: {
                self.directionarrow.transform = CGAffineTransform(rotationAngle: CGFloat(degreevalueAtmaxfreq * M_PI/180))
            })

        }
        //close direction
    }
    
    
    
}


