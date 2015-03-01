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
    
    var photos : NSMutableArray = NSMutableArray()
    
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
        
        PFObject.saveAllInBackground(photos, block: { (succeeded, error) -> Void in
            if succeeded {
                println("Success!")
            }
            else {
                println(error)
            }
        })
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentSize.height - scrollView.contentOffset.y < (self.view.bounds.size.height*2)) {
            if (!self.loading) {
                self.loadNextPage()
            }
        }
    }
    
    
    
    
}