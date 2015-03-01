//
//  ViewController.swift
//  WhereAmI
//
//  Created by Brian Kincade on 2/28/15.
//  Copyright (c) 2015 Brian Kincade. All rights reserved.
//


import UIKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var manager : CLLocationManager!
    var latitude : Double?
    var longitude : Double?
    var stringurl : String?
    var ids : NSMutableArray = NSMutableArray()
    var pictureurls : NSMutableArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var locValue : CLLocationCoordinate2D
        locValue = manager.location.coordinate
        latitude = locValue.latitude
        longitude = locValue.longitude
//        println(latitude)
//        println(longitude)
        manager.stopUpdatingLocation()
        stringurl = "https://api.instagram.com/v1/locations/search?lat=\(latitude!)&lng=\(longitude!)&distance=5000&client_id=fc4a0003032345b79949e8931810577c"
//        println(stringurl)
        getInstagramData(stringurl!)
        
    }
    //  func connection(
    
    func getInstagramData(purl : String){
        
        var url = NSURL(string: purl)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            //     println(NSString(data: data, encoding: NSUTF8StringEncoding))
            //      println(data)
            //      println("got here")
            self.parseLocationData(data)
        }
        
        task.resume()
        
    }
    
    
    func parseLocationData(jsonData : NSData){
        var parseError: NSError?
        let parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData,
            options: NSJSONReadingOptions.AllowFragments,
            error:&parseError)
        
        if let insta = parsedObject as? NSDictionary
        {
            if let data = insta["data"] as? NSArray
            {
                for object in data
                {
                    if var uid = object["id"] as? NSString
                    {
                        ids.addObject(uid)
                    }
                }
            }
        }
        
        getPictures(ids)
        
    }
    
    func getPictures(idNumbers : NSMutableArray){
        
        var pictureString = "https://api.instagram.com/v1/locations/"
        var remainder = "/media/recent?client_id=fc4a0003032345b79949e8931810577c"
        var picURLString = ""
        
        
        for object in idNumbers
        {
            var obj: String = object as String
            // var obj: String = idNumbers[1] as String
            picURLString = pictureString + obj  + remainder
            //println(finalURL)
            var picurl = NSURL(string: picURLString)
            let pictask = NSURLSession.sharedSession().dataTaskWithURL(picurl!) {(data, response, error) in
                // println(NSString(data: data, encoding: NSUTF8StringEncoding))
                //  println(data)
                //  println("got here")
                self.parseIDData(data)
                
                // println(picurl)
            }
            pictask.resume()
            
            
        }
        println("DONE")
        
        
        
    }
    
    func parseIDData(jsonData: NSData){
        var parseError: NSError?
        let parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData,
            options: NSJSONReadingOptions.AllowFragments,
            error:&parseError)
        if let instapics = parsedObject as? NSDictionary
        {
            if let picdata = instapics["data"] as? NSArray
            {
                
                for object in picdata{
                    
                    if var images = object["images"] as? NSDictionary
                    {
                        if var stdres = images["standard_resolution"] as? NSDictionary
                        {
                            if var imurl = stdres["url"] as? NSString{
                                // println(imurl)
                                pictureurls.addObject(imurl)
                            }
                        }
                    }
                    
                }
            }
        }
//        println(pictureurls)
        
//        for urlString in pictureurls {
//            
//        }
    }
    
    
    
    @IBAction func seePics(sender: AnyObject)
    {
//        navigationController.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "seePics" {
            
            
            var mainFeedVC: MainFeedViewController = segue.destinationViewController as MainFeedViewController
            mainFeedVC.imgDataArray = pictureurls
        }
    }
    
    
    
}



