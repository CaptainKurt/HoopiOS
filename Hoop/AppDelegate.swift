//
//  AppDelegate.swift
//  Hoop
//
//  Created by Kurt Walker on 2/28/15.
//  Copyright (c) 2015 Hoop. All rights reserved.
//

import UIKit
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
//    var manager : CLLocationManager!
//    var latitude : Double?
//    var longitude : Double?
//    var stringurl : String?
//    var ids : NSMutableArray = NSMutableArray()
//    var pictureurls : NSMutableArray = NSMutableArray()
//    var photos : NSMutableArray = NSMutableArray()
//    var photoLocations : NSMutableArray = NSMutableArray()
//    var photoDates : NSMutableArray = NSMutableArray()

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
//        Parse.enableLocalDatastore()
        
        Parse.setApplicationId("d5NQERKjVbCXIdTMYtgsNlPy8P6crh5XbRfxmbbL", clientKey: "th4RsOudetzjdYMI8OU9vNAxTYkVB3A1goiB9Mja")

        Photo.registerSubclass()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
//        manager = CLLocationManager()
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
//        manager.requestAlwaysAuthorization()
//        manager.startUpdatingLocation()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    // MARK: - Load Instagram Images
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                println("Error: " + error.localizedDescription)
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                self.displayLocationInfo(pm)
            }
            else {
                println("Error with data")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark)
    {
        self.locationManager.stopUpdatingLocation()
        
        println(placemark.locality)
        println(placemark.postalCode)
        println(placemark.administrativeArea)
        println(placemark.country)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error: " + error.localizedDescription)
    }
    
    
}

