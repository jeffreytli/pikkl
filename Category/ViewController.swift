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

    @IBAction func loginFB(sender: AnyObject) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email"],
            block: { (user:PFUser?, error:NSError?) -> Void in
            if(error != nil) {
                // Display an alert message
                var myAlert = UIAlertController(title:"Alert", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                myAlert.addAction(okAction);
                self.presentViewController(myAlert, animated: true, completion: nil)
                
                return
            }
                print(user)
                print("Current user token = \(FBSDKAccessToken.currentAccessToken().tokenString)")
                print("Current user ID = \(FBSDKAccessToken.currentAccessToken().userID)")
          
                if (FBSDKAccessToken.currentAccessToken() != nil){
                    let protectedPage = self.storyboard?.instantiateViewControllerWithIdentifier("NewUserViewController") as! NewUserViewController
                    
                    let protectedPageNav = UINavigationController(rootViewController: protectedPage)
                    
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    appDelegate.window?.rootViewController = protectedPage
                }
        })
    }

    // Description: Make a Facebook Graph request and get basic user information
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters:["fields": "name, email, friends"])
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
}