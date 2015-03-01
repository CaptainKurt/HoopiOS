//
//  ImageFeed.swift
//  Hoop
//
//  Created by Kurt Walker on 3/1/15.
//  Copyright (c) 2015 Hoop. All rights reserved.
//

import UIKit

class ImageFeed: PFQueryTableViewController {
    
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
   
}
