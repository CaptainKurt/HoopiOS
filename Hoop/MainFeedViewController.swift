//
//  MainFeedViewController.swift
//  Hoop
//
//  Created by Kurt Walker on 2/28/15.
//  Copyright (c) 2015 Hoop. All rights reserved.
//
import UIKit

class MainFeedViewController: PFQueryTableViewController, CLLocationManagerDelegate, ImageCellDelegate
{
    var firstLocation: CLLocation?
    var photos : NSMutableArray = NSMutableArray()
    var reusableSectionHeaderViews: NSMutableSet = NSMutableSet()
    
    var manager : CLLocationManager!
    var latitude : Double?
    var longitude : Double?
    var stringurl : String?
    var ids : NSMutableArray = NSMutableArray()
    var pictureurls : NSMutableArray = NSMutableArray()
    var instaPhotos : NSMutableArray = NSMutableArray()
    var photoLocations : NSMutableArray = NSMutableArray()
    var photoDates : NSMutableArray = NSMutableArray()
    
    var shouldApplyFilter: Bool = false
    
    @IBOutlet weak var sortButton: UIBarButtonItem!
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "Photo"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavBar()
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    override func queryForTable() -> PFQuery! {
        
        
        var query = PFQuery(className: "Photo")
        
        if self.objects.count == 0 {
            query.cachePolicy = kPFCachePolicyCacheThenNetwork
        }
        
        if shouldApplyFilter == false {
            query.addDescendingOrder("date")
        } else {
            query.addDescendingOrder("score")
        }
        
        query.includeKey("disrespectArray")
        query.includeKey("respectArray")
        
        return query
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var sections: Int = self.objects.count
        if self.paginationEnabled && sections != 0 {
            sections++
        }
        return sections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.mainScreen().bounds.width + 41
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UIScreen.mainScreen().bounds.width + 41
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == self.objects.count) {
            return 0
        }
        
        return 40
    }
    
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if indexPath.section >= self.objects.count {
//            return 44
//        }
//        
//        return UIScreen.mainScreen().bounds.height + 41
//    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == self.objects.count {
            return nil
        }
        
        var header: HeaderCell? = self.dequeueReusableSectionHeaderView()
        
        if header == nil {
            header = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as? HeaderCell
            self.reusableSectionHeaderViews.addObject(header!)
        }
        
        var photo: Photo = self.objects[section] as Photo
        header?.scoreLabel.text = "\(photo.score)"
        header?.locationLabel.text = "\(photo.location)"
        
        return header
    }
    
    func dequeueReusableSectionHeaderView() -> HeaderCell? {
        for sectionHeaderView in self.reusableSectionHeaderViews
        {
            if sectionHeaderView.superview == nil {
                return sectionHeaderView as? HeaderCell
            }
        }
        
        return nil
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
    
        if indexPath.section == self.objects.count {
            var cell = self.tableView(tableView, cellForNextPageAtIndexPath: indexPath)
            return cell
        } else {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as? ImageCell
            
            if cell == nil {
                println("new cell")
            }
            
            var photo: Photo = object as Photo
            cell?.photo = photo
            var file: PFFile? = photo.imageFile
            
            if file != nil {
                cell?.img.file = file
                cell?.img.loadInBackground()
            }
            else {
                cell?.img.image = UIImage(named: "1@2x.jpg")
            }
            
            cell?.section = indexPath.section
            
            cell?.setButton()
            cell?.delegate = self
            
            
            return cell!
        }
        
    }
    
    
    
    
    override func tableView(tableView: UITableView!, cellForNextPageAtIndexPath indexPath: NSIndexPath!) -> PFTableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("LoadMoreCell") as LoadMoreCell
        
        return cell
    }
    
    override func objectAtIndexPath(indexPath: NSIndexPath!) -> PFObject! {
        if indexPath.section < self.objects.count {
            return self.objects[indexPath.section] as PFObject
        }
        return nil
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
    
    
    func setUpNavBar()
    {
//        self.navigationController?.navigationBar.barTintColor = UIColor(red: 241, green: 85, blue: 86, alpha: 1.0)
//        
//        self.navigationController?.navigationBar.tintColor = UIColor(red: 241, green: 85, blue: 86, alpha: 1.0)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "RedBackground"), forBarMetrics: UIBarMetrics.Default)
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, 70, 32))
        let image = UIImage(named: "lilhoop")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    func updateScoreLabel(section: Int, newScore: Int) {
        
//        var header = self.tableView?.headerViewForSection(section)! as HeaderCell
//        header.scoreLabel.text = "\(newScore)"
    }
    
    
    @IBAction func sortButtonPressed(sender: AnyObject)
    {
        if sortButton.title == "TRENDING" {
            self.sortButton.title = "SURF"
            shouldApplyFilter = true
            self.loadObjects()
        }
        else {
            self.sortButton.title = "TRENDING"
            shouldApplyFilter = false
            self.loadObjects()
        }
    }
    
    
    
    
    
    
    
    
    
    // MARK: - Get Instagram Photos
    
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var newLocation: CLLocation = locations.last as CLLocation
        if (self.firstLocation != nil) {
            // app already has a location
            var locationAge =  newLocation.timestamp.timeIntervalSinceDate(firstLocation!.timestamp)
            println("locationAge: \(locationAge)")
            if (locationAge < 120.0) {  // 120 is in seconds or milliseconds?
                return
            }
        } else {
            self.firstLocation = newLocation;
        }
        
        manager.stopUpdatingLocation()
        var locValue : CLLocationCoordinate2D
        locValue = manager.location.coordinate
        latitude = locValue.latitude
        longitude = locValue.longitude
//        manager.stopUpdatingLocation()
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
//                println("------------------------")
//                println("DATA: \(data)")
//                println("------------------------")
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
        
        var query = PFQuery(className: "Photo")
        var lastPhoto: Photo? = query.getFirstObject() as? Photo
        var lastDateUNIX: NSTimeInterval?
        if lastPhoto != nil {
            var lastDate: NSDate = lastPhoto!.date
            lastDateUNIX = lastDate.timeIntervalSince1970
        }
        
        var pictureString = "https://api.instagram.com/v1/locations/"
        var remainder = "/media/recent?client_id=fc4a0003032345b79949e8931810577c"
        if lastDateUNIX != nil {
            remainder = "\(lastDateUNIX)/media/recent?client_id=fc4a0003032345b79949e8931810577c"
        }
        
        for object in idNumbers
        {
            var obj: String = object as String
            
            var picURLString = pictureString + obj  + remainder
            
            var picurl = NSURL(string: picURLString)
            let pictask = NSURLSession.sharedSession().dataTaskWithURL(picurl!) {(data, response, error) in
                self.parseIDData(data)
//                 println(data)
            }
            pictask.resume()
        }
    }
    
    func parseIDData(jsonData: NSData){
        
        
        
        var newPhotos: NSMutableArray = NSMutableArray()
        var queries: NSMutableArray = NSMutableArray()
        var parseError: NSError?
        let parsedObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData,
            options: NSJSONReadingOptions.AllowFragments,
            error:&parseError)
//        var queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//        dispatch_async(queue, { () -> Void in
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
                        newPhotos.addObject(photo)
                        
                        var query: PFQuery = PFQuery(className: "Photo")
                        query.whereKey("imageID", equalTo: photo.imageID)
                        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                            if objects.count > 0 {
                                
                            }
                            else {
                                self.instaPhotos.addObject(photo)
                            }
                        })
                        
                        //                    println(photo)
                        
                    }
                }
                
            }
        
        PFObject.saveAllInBackground(newPhotos, block: { (succeeded, error) -> Void in
            if succeeded {
                println("SUCCESS!")
            }
            else {
                println(error)
            }
        })
        
//            PFObject.saveAllInBackground(self.instaPhotos, block: { (succeeded, error) -> Void in
//                if succeeded {
//                    println("SUCCESS!")
//                }
//                else {
//                    println(error)
//                }
//            })
////        })
        println("Done Loading Images")
        
        
        
//        
//        var queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//        dispatch_async(queue, { () -> Void in
//
//            // Use dispatch_apply instead significantly improves performance time when the number of users is large.
//            dispatch_apply(UInt(self.instaPhotos.count), queue, { (i) -> Void in
//                
//                var instaPhoto: Photo = self.instaPhotos.objectAtIndex(Int(i)) as Photo
//                
//                var query: PFQuery = PFQuery(className: "Photo")
//                query.where
//                
//            })
//        })
    

        
        
    }
    
    
}