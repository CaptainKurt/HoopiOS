//
//  Photo.swift
//  Hoop
//
//  Created by Brian Kincade on 2/28/15.
//  Copyright (c) 2015 Hoop. All rights reserved.
//

import Foundation

class Photo: PFObject, PFSubclassing {
    
    //@NSManaged var author: User
    // @NSManaged var likes: NSMutableArray
    @NSManaged var tags: String
    @NSManaged var imageFile: PFFile
    @NSManaged var location: String
    @NSManaged var score: Int
    @NSManaged var date: NSDate
    @NSManaged var imageID: String
    
    
    func convertURL(urlString: String) {
        var newURL = NSURL(string: urlString)
        var dataURL = NSData(contentsOfURL: newURL!)
        imageFile = PFFile(data: dataURL)
    }
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "Photo"
    }
}