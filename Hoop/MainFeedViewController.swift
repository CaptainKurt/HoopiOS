//
//  MainFeedViewController.swift
//  Hoop
//
//  Created by Kurt Walker on 2/28/15.
//  Copyright (c) 2015 Hoop. All rights reserved.
//
import UIKit

class MainFeedViewController: PFQueryTableViewController, CLLocationManagerDelegate
{
//    var imgDataArray: NSMutableArray = NSMutableArray()
//    var photos: NSArray = NSArray()
    
    
    
    var manager : CLLocationManager!
    var latitude : Double?
    var longitude : Double?
    var stringurl : String?
    var ids : NSMutableArray = NSMutableArray()
    var pictureurls : NSMutableArray = NSMutableArray()
    var photos : NSMutableArray = NSMutableArray()
    var photoLocations : NSMutableArray = NSMutableArray()
    var photoDates : NSMutableArray = NSMutableArray()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "Photo"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func queryForTable() -> PFQuery! {
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        PFObject.saveAllInBackground(photos, block: { (succeeded, error) -> Void in
            if succeeded {
                println("Success!")
            }
        })
        
        var query = PFQuery(className: "Photo")
        
        if self.objects.count == 0 {
            query.cachePolicy = kPFCachePolicyCacheThenNetwork
        }
        
        
        return query
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 400
    }
    
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as? ImageCell
        
        var photo: PFObject = object as PFObject
        var file: PFFile? = photo.objectForKey("imageFile") as? PFFile
        
        if file != nil {
            cell?.img.file = file
            cell?.img.loadInBackground({ (succeeded, error) -> Void in
                if error == nil {
                    println("image loaded")
                }
                else {
                    println(error)
                }
            })
        }
        else {
            cell?.img.image = UIImage(named: "1@2x.jpg")
        }
        
        //                cell?.img.image = UIImage(data: NSData(contentsOfURL: URL!)!)
        
        
        return cell!
        
    }
    
    override func objectsDidLoad(error: NSError!) {
        super.objectsDidLoad(error)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentSize.height - scrollView.contentOffset.y < (self.view.bounds.size.height*2)) {
            if (!self.loading) {
                self.loadNextPage()
            }
        }
    }
    
    
    
    
    
    
    
    // MARK: - Get Instagram Image
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var locValue : CLLocationCoordinate2D
        locValue = manager.location.coordinate
        latitude = locValue.latitude
        longitude = locValue.longitude
        manager.stopUpdatingLocation()
        stringurl = "https://api.instagram.com/v1/locations/search?lat=\(latitude!)&lng=\(longitude!)&distance=5000&client_id=fc4a0003032345b79949e8931810577c"
        getInstagramData(stringurl!)
        
    }
    
    func getInstagramData(purl : String){
        
        var url = NSURL(string: purl)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            
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
            
            picURLString = pictureString + obj  + remainder
            
            var picurl = NSURL(string: picURLString)
            let pictask = NSURLSession.sharedSession().dataTaskWithURL(picurl!) {(data, response, error) in
                self.parseIDData(data)
                // println(picurl)
            }
            pictask.resume()
        }
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
                    var photo : Photo = Photo()
                    
                    if var unixDate: String = object["created_time"] as? String{
                        //photoDates.addObject(date)
                        
                        var date: Int = unixDate.toInt()!
                        
                        var time = Double(date)
                        
                        var newDate = NSDate(timeIntervalSince1970: time)
                        //var time : NSTimeInterval = NSTimeInterval(
                        
                        //var date = unixDate as Int
                        photo.date = newDate
                        // println(dateInt)
                        //println(date)
                        
                    }
                    
                    if var location = object["location"] as? NSDictionary
                    {
                        if var name = location["name"] as?NSString{
                            //photoLocations.addObject(name)
                            photo.location = name
                        }
                    }
                    
                    if var imageID = object["id"] as? String {
                        photo.imageID = imageID
                    }
                    
                    if var images = object["images"] as? NSDictionary
                    {
                        if var stdres = images["standard_resolution"] as? NSDictionary
                        {
                            if var imurl = stdres["url"] as? NSString{
                                // println(imurl)
                                //pictureurls.addObject(imurl)
                                photo.convertURL(imurl)
                            }
                        }
                    }
                    
                    photos.addObject(photo)
                    println(photo)
                    
                }
            }
        }
        println("Done Loading Images")
    }
    
    
}