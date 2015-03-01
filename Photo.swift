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
//    @NSManaged var tags: String
    @NSManaged var imageFile: PFFile
    @NSManaged var urlString: String
//    @NSManaged var location: String
//    @NSManaged var caption: String
//    @NSManaged var score: Int
    
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "Photo"
    }
}
