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
        
        self.navigationController?.navigationBarHidden = true
        
        var currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            print("EXISTING USER")
            if (currentUser!.username != nil){
                print("EXISTING USER - HAS USERNAME")
                // Redirect directly to BattlesViewController
                let protectedPage = self.storyboard?.instantiateViewControllerWithIdentifier("BattlesTableViewController") as! BattlesTableViewController

                let protectedPageNav = UINavigationController(rootViewController: protectedPage)
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.window?.rootViewController = protectedPageNav
            }
            print("EXISTING USER - NO USERNAME")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Description: Implements the logic to login to Facebook if the user doesn't currently have a 
    // username or FacebookID registered in the Parse database.
    @IBAction func loginFB(sender: AnyObject) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email", "user_friends"],
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
                
                // After registering the Facebook information, redirect page to allow the user
                // to select a username
                let protectedPage = self.storyboard?.instantiateViewControllerWithIdentifier("NewUserViewController") as! NewUserViewController
                
                let protectedPageNav = UINavigationController(rootViewController: protectedPage)
                
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                appDelegate.window?.rootViewController = protectedPage
        })
    }
}