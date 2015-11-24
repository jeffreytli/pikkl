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
        
        setSubmissionLabels()
        
        self.activityIndicator.transform = CGAffineTransformMakeScale(2, 2)
        self.activityIndicator.startAnimating()
        
        setSubmissionImage()
        
        self.activityIndicator.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSubmissionLabels() -> Void {
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
    }
    
    func setSubmissionImage() -> Void {
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
    }
    
    @IBAction func btnCastVote(sender: AnyObject) {
        var userHasVoted = currentEntry!["userHasVoted"] as! Dictionary<String, Bool>
        let curUserId:String = PFUser.currentUser()!.objectId!
        
        dispatch_async(dispatch_get_main_queue()) {
            if(userHasVoted[curUserId] == nil) {
                self.showVoteConfirmationAlert(userHasVoted, curUserId: curUserId)
            } else {
                self.showVoteFailureAlert()
            }
        }
    }
    
    func showVoteConfirmationAlert(userHasVoted: Dictionary<String, Bool>, curUserId: String) -> Void {
        let alertController = UIAlertController(title: "Cast Vote", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
            (action:UIAlertAction) in
            
            // Save to Parse database
            self.saveVoteEntry(userHasVoted, curUserId: curUserId)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default){
            (action:UIAlertAction) in
            // Do nothing
        }
        
        alertController.addAction(OKAction)
        alertController.addAction(cancelAction)
        
        // Return to previous view
        self.presentViewController(alertController, animated: true, completion:nil)
    }
    
    func showVoteFailureAlert() -> Void {
        let alertController = UIAlertController(title: "", message:
            "You can only vote once per entry.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func saveVoteEntry(var userHasVoted: Dictionary<String, Bool>, curUserId: String) -> Void {
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
    
    @IBAction func sliderVoteChanged(sender: UISlider) {
        let currentValue = Int(sender.value)
        
        lblVoteScore.text = "\(currentValue)"
    }
}