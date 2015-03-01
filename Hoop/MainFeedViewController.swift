//
//  MainFeedViewController.swift
//  Hoop
//
//  Created by Kurt Walker on 2/28/15.
//  Copyright (c) 2015 Hoop. All rights reserved.
//

import UIKit

class MainFeedViewController: UITableViewController
{
    var imgDataArray: NSMutableArray = NSMutableArray()
    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        self.parseClassName = "Photo"
//        self.pullToRefreshEnabled = true
//        self.paginationEnabled = true
//        self.objectsPerPage = 10
//    }
    
    override func viewDidLoad() {
        
        for imgURLString in imgDataArray {
            let string: String = imgURLString as String
            let data = NSData(contentsOfURL: NSURL(string: string)!)
            var file = PFFile(data: data)
            
            file.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                if error != nil {
                    var photoObject = PFObject(className: "Photo")
                    photoObject.addObject(string, forKey: "urlString")
                    
                }
            })
            
            
        }
    }
    
    
//    override func queryForTable() -> PFQuery! {
//        
//        
//        var query = PFQuery(className: "Photo")
//        
//        if self.objects.count == 0 {
//            query.cachePolicy = kPFCachePolicyCacheThenNetwork
//        }
//        
//        
//        return query
//    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 428
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imgDataArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as? ImageCell
        
        var imgURL = imgDataArray.objectAtIndex(indexPath.row) as String
        let URL = NSURL(string: imgURL)
        let data = NSData(contentsOfURL: URL!)
        let file = PFFile(data: data)
        
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
        
//        cell?.img.image = UIImage(data: NSData(contentsOfURL: URL!)!)
        
        
        return cell!
    }
    
   
}
