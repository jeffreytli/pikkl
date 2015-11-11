//
//  VoteForEntryViewController.swift
//  pikkl
//
//  Created by Julio Correa on 11/7/15.
//  Copyright © 2015 CS378. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Parse
import ParseFacebookUtilsV4
import CoreData

class VoteForEntryViewController: UIViewController {
    
    @IBOutlet weak var imgEntry: UIImageView!
    
    //@IBOutlet weak var fieldVote: UITextField!
    
    @IBOutlet weak var sliderLabel: UILabel!
    
    var currentEntry:PFObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userImageFile = currentEntry!["image"] as! PFFile
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    self.imgEntry.image = image
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func voteSlider(sender: UISlider) {
        var sliderValue = lroundf(sender.value)
        sliderLabel.text = "\(sliderValue)"
    }
    
    @IBAction func btnCastVote(sender: AnyObject) {
        var userHasVoted = currentEntry!["userHasVoted"] as! Dictionary<String, Bool>
        let curUserId:String = PFUser.currentUser()!.objectId!
        
        //if to prevent voting more than once per entry
        if(userHasVoted[curUserId] == nil) {
            var tempVote = currentEntry!["score"] as! Int
            tempVote += Int(sliderLabel.text!)!
            currentEntry!["score"] = tempVote
            var tempNumVoters = currentEntry!["numVoters"] as! Int
            tempNumVoters++
            currentEntry!["numVoters"] = tempNumVoters
            userHasVoted.updateValue(true, forKey: curUserId)
            currentEntry!["userHasVoted"] = userHasVoted
            currentEntry?.saveInBackground()
        } else {
            //has already voted, figure out what to do for this case?
            print("you can't vote twice on the same entry!!")
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}