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
    @IBOutlet weak var lblVoteScore: UILabel!
    @IBOutlet weak var sliderVote: UISlider!
    @IBOutlet weak var btnCastVote: UIButton!
    @IBOutlet weak var lblYourEntry: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var currentEntry:PFObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellOwnerId:String = (currentEntry!["owner"] as! PFUser).valueForKey("objectId")! as! String
        let curUserId:String = PFUser.currentUser()!.valueForKey("objectId")! as! String
        if(cellOwnerId  == curUserId) {
            lblVoteScore.hidden = true
            sliderVote.hidden = true
            btnCastVote.hidden = true
            lblYourEntry.text = "This is your entry, ya can't vote on it!"
        } else {
            lblYourEntry.hidden = true
        }
        let userImageFile = currentEntry!["image"] as! PFFile
        self.activityIndicator.transform = CGAffineTransformMakeScale(2, 2)
        self.activityIndicator.startAnimating()
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    self.imgEntry.image = image
                }
            }
        }
        self.activityIndicator.stopAnimating()

        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCastVote(sender: AnyObject) {
        var userHasVoted = currentEntry!["userHasVoted"] as! Dictionary<String, Bool>
        let curUserId:String = PFUser.currentUser()!.objectId!
        
        dispatch_async(dispatch_get_main_queue()) {
            if(userHasVoted[curUserId] == nil) {
                let alertController = UIAlertController(title: "Cast Vote", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
                    (action:UIAlertAction) in
                    // Save to Parse database and return to previous view
                    //self.navigationController?.popViewControllerAnimated(true)
                    
                    var tempVote = self.currentEntry!["score"] as! Int
                    tempVote += Int(self.lblVoteScore.text!)!
                    self.currentEntry!["score"] = tempVote
                    var tempNumVoters = self.currentEntry!["numVoters"] as! Int
                    tempNumVoters++
                    self.currentEntry!["numVoters"] = tempNumVoters
                    userHasVoted.updateValue(true, forKey: curUserId)
                    self.currentEntry!["userHasVoted"] = userHasVoted
                    self.currentEntry?.saveInBackground()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default){
                    (action:UIAlertAction) in
                    // Do nothing
                }
                
                alertController.addAction(OKAction)
                alertController.addAction(cancelAction)
                
                self.presentViewController(alertController, animated: true, completion:nil)
            } else {
                let alertController = UIAlertController(title: "", message:
                    "You can only vote once per entry.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func sliderVoteChanged(sender: UISlider) {
        let currentValue = Int(sender.value)
        
        lblVoteScore.text = "\(currentValue)"
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