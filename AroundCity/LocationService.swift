//
//  LocationService.swift
//  AroundCity
//
//  Created by liuzhihui on 16/8/16.
//  Copyright © 2016年 liuzhihui. All rights reserved.
//

import UIKit
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationService()
    let locationManager = CLLocationManager()
    //private initialization to ensure just one instance is created.
    private override init() {
        
    }
    
    var deferredLocationUpdate = false
    dynamic var nowLoc: CLLocation?
    
    func initLocationManager() {
        locationManager.delegate = self
        locationManager.activityType = CLActivityType.Fitness
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startUpdateLocaton() {
        initLocationManager()
        locationManager.startUpdatingLocation()
        nowLoc = CLLocation.init(latitude: 36.561325, longitude: 136.656205)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //
        if !deferredLocationUpdate {
            let distance: CLLocationDistance = 100.0
            let time: NSTimeInterval = 60.0
            locationManager.allowDeferredLocationUpdatesUntilTraveled(distance, timeout: time)
            
            deferredLocationUpdate = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didFinishDeferredUpdatesWithError error: NSError?) {
        
        deferredLocationUpdate = false
        
        //get open source information
        nowLoc = manager.location
    }
}
