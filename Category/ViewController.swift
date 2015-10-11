//
//  ViewController.swift
//  Category
//
//  Created by Julio Correa on 10/3/15.
//  Copyright © 2015 CS378. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Parse
import ParseFacebookUtilsV4

class ViewController: UIViewController{

    @IBOutlet weak var btnFBLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Description: Make a Facebook Graph request and get basic user information
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                // Process error
                print("Error: \(error)")
            }
            else {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                //let userEmail : NSString = result.valueForKey("email") as! NSString
                //print("User Email is: \(userEmail)")
            }
        })
    }
    
    @IBAction func loginFB(sender: AnyObject) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email"], block: { (user:PFUser?, error:NSError?) -> Void in
            if(error != nil) {
                //TODO display an alert message (from youtube vid)
                print("ERROR!!")
            }
            
//            print(user)
//            print("Current user token = \(FBSDKAccessToken.currentAccessToken().tokenString)")
//            print("Current user ID = \(FBSDKAccessToken.currentAccessToken().userID)")
            
            if let user = user {
                // User successfully logged into Facebook
                if user.isNew {
                    print("User signed up and logged in through Facebook!")
                } else {
                    print("User logged in through Facebook!")
                }
                
                // Create request for user's Facebook data
                let request = FBSDKGraphRequest(graphPath:"me", parameters:nil)
                
                // Send request to Facebook
                request.startWithCompletionHandler {
                    (connection, result, error) in
                    if error != nil {
                        // Some error checking here
                    }
                    else if let userData = result as? [String:AnyObject] {
                        // Access user data
                        let username = userData["name"] as? String
                        user["fullname"] = username;
                        user.saveInBackground()
                        print(username)
                    }
                }
                // User failed to log into Facebook
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
            
            print((user?.username)!)
            
//            if(FBSDKAccessToken.currentAccessToken() != nil) {
//                let protectedPage = self.storyboard?.instantiateViewControllerWithIdentifier("BattleTVC") as! BattleTableViewController
//                
//                let protectedPageNav = UINavigationController(rootViewController: protectedPage)
//                
//                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//                
//                appDelegate.window?.rootViewController = protectedPage
//            }
        })

    }
}

