//
//  NewUserViewController.swift
//  Category
//
//  Created by Jeffrey Li on 10/11/15.
//  Copyright © 2015 CS378. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4

class NewUserViewController: UIViewController {
    
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var btnSaveUsername: UIButton!
    
    // Initialize a Parse/Facebook user
    var user:PFUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPFUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Desc: Save the username in Parse
    @IBAction func btnSaveUsername(sender: AnyObject) {
        self.user = PFUser.currentUser()!
    
        if (!textFieldUsername.text!.isEmpty){
            self.user!.setObject(textFieldUsername.text!, forKey: "username")
            self.user!.saveInBackground()
        }
        
        // After saving the username details, redirect to the Battles Page
        let protectedPage = self.storyboard?.instantiateViewControllerWithIdentifier("BattlesViewController") as! BattlesViewController
        
        let protectedPageNav = UINavigationController(rootViewController: protectedPage)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = protectedPage
    }
    
    // Desc: Make a Facebook Graph request and pull all of the necessary
    //       user information. Make the request and set up the PFUser and save
    //       in the Parse data base.
    func setPFUser() -> Void {
        // Facebook request parameters for a user
        var requestParameters = ["fields": "id, email, first_name, last_name"]
        
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        
        userDetails.startWithCompletionHandler{ (connection, result, error:NSError!) -> Void in
            if (error != nil){
                print("\(error.localizedDescription)")
                return
            }
            
            if (result != nil){
                let userId:String = result["id"] as! String
                let userFirstName:String? = result["first_name"] as? String
                let userLastName:String? = result["last_name"] as? String
                let userEmail:String? = result["email"] as? String
                
                self.user = PFUser.currentUser()!
                
                // Save first name
                if(userFirstName != nil){
                    self.user!.setObject(userFirstName!, forKey: "first_name")
                }
                
                // Save last name
                if(userLastName != nil){
                    self.user!.setObject(userLastName!, forKey: "last_name")
                }
                
                // Save email-address
                if(userEmail != nil){
                    self.user!.setObject(userEmail!, forKey: "email")
                }
                
                // We need to dispatch an async task to perform this data fetching/downloading in the background. Otherwise app will appear to freeze for user
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    // Save and get Facebook profile picture
                    var userProfilePicture = "https://graph.facebook.com/" + userId + "/picture?type=large"
                    
                    let profilePictureUrl = NSURL(string: userProfilePicture)
                    let profilePictureData = NSData(contentsOfURL: profilePictureUrl!)
                    
                    if(profilePictureData != nil){
                        let profileFileObject = PFFile(data:profilePictureData!)
                        self.user!.setObject(profileFileObject, forKey: "profilePicture")
                    }
                    
                    self.user!.saveInBackgroundWithBlock({(success:Bool, error:NSError?) -> Void in
                        if(success){
                            print("User details are now updated")
                        }
                    })
                }
            }
        }
    }
}
