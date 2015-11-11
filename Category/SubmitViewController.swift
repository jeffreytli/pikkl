//
//  SubmitViewController.swift
//  pikkl
//
//  Created by Julio Correa on 10/25/15.
//  Copyright © 2015 CS378. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Parse
import ParseFacebookUtilsV4
import CoreData


class SubmitViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   // @IBOutlet weak var lblBattleTitle: UILabel!
    @IBOutlet weak var imgSubmit: UIImageView!
    @IBOutlet weak var lblBattleTitle: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    
    let imagePicker = UIImagePickerController()
    var imgUploaded:Bool = false;
    var battleTitle:String = ""
    var battleID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imgSubmit.image = UIImage(named: "SubmitCamera")
        lblBattleTitle.text = battleTitle

    }
    
    override func shouldAutorotate() -> Bool {
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.Unknown) {
                return false;
        }
        else {
            return true;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgSubmit.contentMode = .ScaleAspectFill
            imgSubmit.image = pickedImage
            imgUploaded = true;
        }
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func imgTapSubmit(sender: AnyObject) {
        //open camera for image upload
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnCreateBattleEntry(sender: AnyObject) {
        //check is a little hacky, couldn't find more elegant way to check for this.
        dispatch_async(dispatch_get_main_queue()) {
            if(self.imgUploaded) {
                let alertController = UIAlertController(title: "Submit photo", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
                    (action:UIAlertAction) in
                    // Save to Parse database and return to previous view
                    //self.navigationController?.popViewControllerAnimated(true)
                    
                    self.createEntry()
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
                    "Please upload a photo to submit.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    //create PF Entry and call method to add Entry to battle object
    func createEntry() -> Void {
        // create battle object
        let entry = PFObject(className:"BattleEntry")
        //saving as JPEG becase png was too large
        let imageData = UIImageJPEGRepresentation(imgSubmit.image!, 1.0)
        let imageFile = PFFile(name:"image.jpg", data:imageData!)
        entry["image"] = imageFile
        entry["owner"] = PFUser.currentUser()
        entry["score"] = 0
        entry["battle"] = battleID
        let user = PFUser.currentUser()
        entry["ownerName"] = user!["username"]
        entry["numVoters"] = 0
        entry["battleName"] = battleTitle
        let userHasVotedDictionary:Dictionary<String, Bool> = [:]
        entry["userHasVoted"] = userHasVotedDictionary
        entry.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                let alertController = UIAlertController(title: "", message:
                    "Photo entry submitted!", preferredStyle: UIAlertControllerStyle.Alert)
                
                let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
                    (action:UIAlertAction) in
                    // Save to Parse database and return to previous view
                    self.navigationController?.popViewControllerAnimated(true)
                }
                
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true, completion:nil)
                // The object has been saved.
                //sleep(1)
            } else {
                print(error?.description)
                // There was a problem, check error.description
                let alertController = UIAlertController(title: "", message:
                    "Photo submission failed, please try again.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        addEntry(entry) //assuming we continue to let battle's keep an array of their entries
    }
    
    //add battle entry to parent battle object
    func addEntry(entryToAdd:PFObject) {
            let query = PFQuery(className:"Battle")
            query.whereKey("objectId", equalTo:battleID)
            query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count)  jobs from database.")
                // Do something with the found objects
                if let objects = objects {
                    
                    for object in objects {
                        print("ObjectId: " + ((object.objectId)! as String))
                        print("BattleName: " + ((object["name"])! as! String))
                        
                        var entries = object["entries"] as! [PFObject]
                        entries.append(entryToAdd)
                        object["entries"] = entries
                        object.saveInBackground()
                    }
                }
            } else {
                //                 Log details of the failure
                print("Error: \(error!)")
            }
        }
    }
    
    func redirectToBattlesTableView() -> Void {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        
        let controller = storyboard.instantiateViewControllerWithIdentifier("BattlesTableViewController") as! BattlesTableViewController
        
        let controllerNav = UINavigationController(rootViewController: controller)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        UIView.transitionWithView(appDelegate.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            appDelegate.window?.rootViewController = controllerNav
            }, completion: nil)
    }
}
