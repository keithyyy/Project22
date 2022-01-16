//
//  ViewController.swift
//  Project22
//
//  Created by Keith Crooc on 2022-01-12.
//

// CHALLENGE
// 1. Write code that shows a UIAlertController when beacon is first detected ✅
// 2. Go through some other iBeacons in Detect Beacon app and add their UUIDs to your app, then register them with iOS. Now add a second label to the app that shows new
// text depending on which beacon was located
// 3. Add a circle to your view, use animation to scale it up/down depending on the distance from the beacon

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var beaconLabel: UILabel!
    var locationManager: CLLocationManager?
    
    var alertBeaconShown = false
    
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
        let uuid2 = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
        
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
//        let beaconRegion1 = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
        
        let beaconRegion2 = CLBeaconRegion(uuid: uuid2, major: 123, minor: 456, identifier: "MyBeacon2")
//        let beaconRegionNew = CLBeaconIdentityConstraint(uuid: uuid2, major: 123, minor: 456)
        
        
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startMonitoring(for: beaconRegion2)

        
        locationManager?.startRangingBeacons(in: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion2)
        

    }
    
    func update(distance: CLProximity, beaconName: String) {
        UIView.animate(withDuration: 1) {
            switch distance {
            
                
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.beaconLabel.text = beaconName
                
                
                
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.beaconLabel.text = beaconName
                
                
                
            case .immediate:
                self.view.backgroundColor = .green
                self.distanceReading.text = "RIGHT HERE"
                self.beaconLabel.text = beaconName
                
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.beaconLabel.text = beaconName
                
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        for beacon in beacons {
            if beacon.uuid == UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5") {
                let beaconID = "Beacon 1"
                update(distance: beacon.proximity, beaconName: beaconID)
                
                if !alertBeaconShown {
                    alertBeacon()
                }
                
                
            } else if beacon.uuid == UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0") {
                let beaconID = "Beacon 2"
                update(distance: beacon.proximity, beaconName: beaconID)
                
                if !alertBeaconShown {
                    alertBeacon()
                }
                
            } else {
                let beaconID = "No Beacon"
                update(distance: .unknown, beaconName: beaconID)
            }
            
        }
        
    
    }
    
//    challenge 1
    func alertBeacon() {
        let ac = UIAlertController(title: "Beacon detected!", message: "There's been a detected near you", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(ac, animated: true)
        
        alertBeaconShown = true
        
    }
    


}

