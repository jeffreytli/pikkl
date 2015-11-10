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
    
    @IBOutlet weak var lblBattleTitle: UILabel!
    @IBOutlet weak var imgSubmit: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var imgUploaded:Bool = false;
    var battleTitle:String = ""
    var battleID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imgSubmit.image = UIImage(named: "SubmitCamera")
        print("battleTitle: \(battleTitle)")
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
        if(imgUploaded) {
            createEntry()
        } else {
            print("can't create entry without image!")
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
                // The object has been saved.
                sleep(1)
            } else {
                // There was a problem, check error.description
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
}
