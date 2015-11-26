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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var btnOne: UIButton!
    @IBOutlet weak var btnTwo: UIButton!
    @IBOutlet weak var btnThree: UIButton!
    @IBOutlet weak var btnFour: UIButton!
    @IBOutlet weak var btnFive: UIButton!
    
    @IBOutlet weak var lblBattleName: UILabel!
    @IBOutlet weak var lblOwnerName: UILabel!

    var currentEntry:PFObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblBattleName.text = (currentEntry!["battleName"] as? String)!
        lblOwnerName.text = (currentEntry!["ownerName"] as? String)!
        
        self.activityIndicator.transform = CGAffineTransformMakeScale(2, 2)
        self.activityIndicator.startAnimating()
        
        setSubmissionImage()
        setAllButtonDetails()
        
        self.activityIndicator.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func buttonTapped(sender:UIButton!) -> Void {
        let cellOwnerIdCheck:String = (currentEntry!["owner"] as! PFUser).valueForKey("objectId")! as! String
        let curUserIdCheck:String = PFUser.currentUser()!.valueForKey("objectId")! as! String
        
        if(cellOwnerIdCheck  == curUserIdCheck) {
            showOwnEntryAlert()
        } else {
            var userHasVoted = currentEntry!["userHasVoted"] as! Dictionary<String, Bool>
            let curUserId:String = PFUser.currentUser()!.objectId!
            
            let voteValue = Int((sender.titleLabel?.text)!)
            
            dispatch_async(dispatch_get_main_queue()) {
                if(userHasVoted[curUserId] == nil) {
                    self.showVoteConfirmationAlert(userHasVoted, curUserId: curUserId, voteValue: voteValue!)
                } else {
                    self.showVoteFailureAlert()
                }
            }
        }
    }
    
    func setButtonDetails(button: UIButton!) -> Void {
        button.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func setAllButtonDetails() -> Void {
        setButtonDetails(btnOne!)
        setButtonDetails(btnTwo!)
        setButtonDetails(btnThree!)
        setButtonDetails(btnFour!)
        setButtonDetails(btnFive!)
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
    
    func showVoteConfirmationAlert(userHasVoted: Dictionary<String, Bool>, curUserId: String, voteValue: Int) -> Void {
        let alertController = UIAlertController(title: "Cast Vote", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
            (action:UIAlertAction) in
            
            // Save to Parse database
            self.saveVoteEntry(userHasVoted, curUserId: curUserId, voteValue: voteValue)
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
    
    func showOwnEntryAlert() -> Void {
        let alertController = UIAlertController(title: "", message:
            "You can not vote for your own entry.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func saveVoteEntry(var userHasVoted: Dictionary<String, Bool>, curUserId: String, voteValue: Int) -> Void {
        var tempVote = self.currentEntry!["score"] as! Int
        tempVote += voteValue
        self.currentEntry!["score"] = tempVote
        var tempNumVoters = self.currentEntry!["numVoters"] as! Int
        tempNumVoters++
        self.currentEntry!["numVoters"] = tempNumVoters
        userHasVoted.updateValue(true, forKey: curUserId)
        self.currentEntry!["userHasVoted"] = userHasVoted
        self.currentEntry?.saveInBackground()
    }
}