//
//  ViewController.swift
//  Project22
//
//  Created by Keith Crooc on 2022-01-12.
//

// CHALLENGE
// 1. Write code that shows a UIAlertController when beacon is first detected
// 2. Go through some other iBeacons in Detect Beacon app and add their UUIDs to your app, then register them with iOS. Now add a second label to the app that shows new
// text depending on which beacon was located
// 3. Add a circle to your view, use animation to scale it up/down depending on the distance from the beacon

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var distanceReading: UILabel!
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
//        alternative for if you decide to make app for only "When in use"
//        locationManager?.requestWhenInUseAuthorization()
        
        
        
        view.backgroundColor = .gray
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
            if CLLocationManager.isRangingAvailable() {
//                do stuff
                startScanning()
            }
        }
    }
    
    func startScanning() {
//        step 1, we'll need a uuid
        
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            
                
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                
            case .immediate:
                self.view.backgroundColor = .green
                self.distanceReading.text = "RIGHT HERE"
                
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    
    


}

