//
//  ImageCell.swift
//  Hoop
//
//  Created by Kurt Walker on 2/28/15.
//  Copyright (c) 2015 Hoop. All rights reserved.
//

import UIKit

protocol ImageCellDelegate {
    func updateScoreLabel(section: Int, newScore: Int)
}

class ImageCell: PFTableViewCell
{
    
    @IBOutlet weak var img: PFImageView!
    @IBOutlet weak var respectButton: UIButton!
    @IBOutlet weak var disrespectButton: UIButton!
//    @IBOutlet weak var scoreLabel: UILabel!
    
    var delegate: ImageCellDelegate?
    var section: Int?
    var photo: Photo?
    var disrespectArray: NSMutableArray = NSMutableArray()
    var respectArray: NSMutableArray = NSMutableArray()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        respectButton.setImage(UIImage(named: "RespectUnselected"), forState: .Normal)
        respectButton.setImage(UIImage(named: "RespectSelected"), forState: .Selected)
        disrespectButton.setImage(UIImage(named: "DisrespectUnselected"), forState: .Normal)
        disrespectButton.setImage(UIImage(named: "DisrespectSelected"), forState: .Selected)
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        if respectButton.selected == true {
//            
//        } else {
//            respectButton.backgroundColor = UIColor.whiteColor()
//            respectButton.titleLabel?.textColor = UIColor.blueColor()
//        }
//        
//        if disrespectButton.selected == true {
//            disrespectButton.backgroundColor = UIColor.redColor()
//            disrespectButton.titleLabel?.textColor = UIColor.whiteColor()
//        } else {
//            disrespectButton.backgroundColor = UIColor.whiteColor()
//            disrespectButton.titleLabel?.textColor = UIColor.redColor()
//        }
    }
    
    func setButton()
    {
//        respectArray = photo?.objectForKey("respectArray") as NSMutableArray
//        disrespectArray = photo?.objectForKey("disrespectArray") as NSMutableArray
//        if photo?.respectArray
        for userRespected in photo!.respectArray {
            var user = userRespected as PFUser
            if user == PFUser.currentUser()
            {
                respectButton.selected = true
                break
            } else {
                respectButton.selected = false
            }
        }
        for userDisrespected in photo!.disrespectArray {
            var user = userDisrespected as PFUser
            if user == PFUser.currentUser()
            {
                disrespectButton.selected = true
                break
            } else {
                disrespectButton.selected = false
            }
        }
    }
    
    
    @IBAction func respectButtonPressed(sender: AnyObject)
    {
        if respectButton.selected == false && disrespectButton.selected == true {
            respectButton.selected = true
            disrespectButton.selected = false
            photo?.removeObject(PFUser.currentUser(), forKey: "disrespectArray")
            photo?.addObject(PFUser.currentUser(), forKey: "respectArray")
//            photo?.disrespectArray.removeObject(PFUser.currentUser())
//            photo?.respectArray.addObject(PFUser.currentUser())
            photo?.score += 2
            delegate?.updateScoreLabel(self.section!, newScore: photo!.score)
            photo?.saveEventually()
            
        }
        else if respectButton.selected == false && disrespectButton.selected == false {
            respectButton.selected = true
//            photo?.removeObject(PFUser.currentUser(), forKey: "disrespectArray")
            photo?.addObject(PFUser.currentUser(), forKey: "respectArray")
//            photo?.respectArray.addObject(PFUser.currentUser())
            photo?.score++
            delegate?.updateScoreLabel(self.section!, newScore: photo!.score)
            photo?.saveEventually()
        }
        
    }
    
    @IBAction func disrespectButtonPressed(sender: AnyObject)
    {
        if respectButton.selected == true && disrespectButton.selected == false {
            disrespectButton.selected = true
            respectButton.selected = false
//            photo?.disrespectArray.removeObject(PFUser.currentUser())
//            photo?.respectArray.addObject(PFUser.currentUser())
            
            photo?.removeObject(PFUser.currentUser(), forKey: "respectArray")
            photo?.addObject(PFUser.currentUser(), forKey: "disrespectArray")
            photo?.score -= 2
            delegate?.updateScoreLabel(self.section!, newScore: photo!.score)
            photo?.saveEventually()
        }
        else if respectButton.selected == false && disrespectButton.selected == false {
            disrespectButton.selected = true
//            photo?.disrespectArray.addObject(PFUser.currentUser())
//            photo?.removeObject(PFUser.currentUser(), forKey: "disrespectArray")
            photo?.addObject(PFUser.currentUser(), forKey: "disrespectArray")
            photo?.score--
            delegate?.updateScoreLabel(self.section!, newScore: photo!.score)
            photo?.saveEventually()
        }
        
    }
    
}
