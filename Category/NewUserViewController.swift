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
    @IBOutlet weak var lblUserTaken: UILabel!
    
    // Initialize a Parse/Facebook user
    var user:PFUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSaveUsername(sender: AnyObject) {
        if (!textFieldUsername.text!.isEmpty){
            if (validUserName(textFieldUsername.text!) == true){
                setPFUser(textFieldUsername.text!)
                
                // After saving the username details, redirect to the Battles Page
                var storyboard = UIStoryboard(name: "Home", bundle: nil)
                
                let controller = storyboard.instantiateViewControllerWithIdentifier("BattlesTableViewController") as! BattlesTableViewController
                
                let controllerNav = UINavigationController(rootViewController: controller)
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.window?.rootViewController = controllerNav
            }
        } else {
            lblUserTaken.text = "Please select a username"
        }
    }
    
    func validUserName(username: String) -> Bool {
        var validUserName = false
        
        do {
            var query = PFUser.query()
            query!.whereKey("username", equalTo: textFieldUsername.text!)
            var usernameP = try query!.findObjects()
            
            if(usernameP.count == 0) {
                print("Valid username")
                validUserName = true
            } else {
                print("Username already taken")
                lblUserTaken.text = "Username already taken"
            }
        } catch {
            print("Something went wrong!")
        }
        
        return validUserName
    }
    
    // Desc: Make a Facebook Graph request and pull all of the necessary
    //       user information. Make the request and set up the PFUser and save
    //       in the Parse data base.
    func setPFUser(username:String) -> Void {
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
                
                // Save username
                self.user!.setObject(username, forKey: "username")
            
                
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
