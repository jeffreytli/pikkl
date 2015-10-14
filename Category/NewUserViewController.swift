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
    // user will be set from sending view controller
    var user:PFUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
                
                // We need to dispatch an async task to perform this data fetching/downloading in the background. 
                // Otherwise, the app will appear to freeze for the user.
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSaveUsername(sender: AnyObject) {
        self.user = PFUser.currentUser()!
        if (!textFieldUsername.text!.isEmpty){
            self.user!.setObject(textFieldUsername.text!, forKey: "username")
            self.user!.saveInBackground()
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
