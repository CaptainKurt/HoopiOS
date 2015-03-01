//
//  MainFeedViewController.swift
//  Hoop
//
//  Created by Kurt Walker on 2/28/15.
//  Copyright (c) 2015 Hoop. All rights reserved.
//

import UIKit

class MainFeedViewController: PFQueryTableViewController
{
    var imgDataArray: NSMutableArray = NSMutableArray()
    var photos: NSArray = NSArray()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
<<<<<<< HEAD
        for imgURLString in imgDataArray {
            let string: String = imgURLString as String
            let data = NSData(contentsOfURL: NSURL(string: string)!)
            var file = PFFile(data: data)
            
            
            file.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                if error != nil {
                    var photoObject = PFObject(className: "Photo")
                    photoObject.addObject(string, forKey: "urlString")
                    photoObject.addObject(file, forKey: "imageFile")
                    
                    photoObject.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                        if error != nil {
                            println("PHOTO SAVED!")
                        }
                        else {
                            println(error)
                        }
                    })
                }
                else {
                    println(error)
                }
            })
            
            
        }
=======
        self.parseClassName = "Photo"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 10
>>>>>>> master1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var files = NSMutableArray()
//        for imgString in imgDataArray {
//            let string = imgString as String
//            let data = NSData(contentsOfURL: NSURL(string: string)!)
//            let file: PFFile = PFFile(data: data)
//            
//            files.addObject(file)
//            
//        }
//        
//        var photos = NSMutableArray()
//        PFObject.saveAllInBackground(files, block: { (succeeded, error) -> Void in
//            if succeeded {
//                for file in files {
//                    var file = file as PFFile
//                    var photo = PFObject(className: "Photo")
//                    photo.setObject(file, forKey: "imageFile")
//                    photos.addObject(photo)
//                }
//                PFObject.saveAllInBackground(photos, block: { (succeeded, error) -> Void in
//                    if succeeded {
//                        println("success!")
//                    }
//                })
//            }
//        })
        
        
        
        
        println("done")
    }
    
    override func queryForTable() -> PFQuery! {
        
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
        
//        if file != nil {
//            cell?.img.file = file
//            cell?.img.loadInBackground({ (succeeded, error) -> Void in
//                if error == nil {
//                    println("image loaded")
//                }
//                else {
//                    println(error)
//                }
//            })
//        }
//        else {
//            cell?.img.image = UIImage(named: "1@2x.jpg")
//        }
        
<<<<<<< HEAD
        cell?.img.image = UIImage(data: NSData(contentsOfURL: URL!)!)
=======
//                cell?.img.image = UIImage(data: NSData(contentsOfURL: URL!)!)
>>>>>>> master1
        
        
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
   
}
