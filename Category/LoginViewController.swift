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

class LoginViewController: UIViewController{

    @IBOutlet weak var btnFBLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        
        let currentUser = PFUser.currentUser()
        
        if currentUser != nil {
            print("EXISTING USER")
            
            if (currentUser!.username != nil){
                print("EXISTING USER - HAS USERNAME (" + currentUser!.username! + ")")
                
                // Redirect directly to BattlesViewController
                redirectToBattlesTableView()
            } else {
                print("EXISTING USER - NO USERNAME")
            }
        }
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
    
    func redirectToNewUserView() -> Void {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("NewUserViewController") as! NewUserViewController
        
        let controllerNav = UINavigationController(rootViewController: controller)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        UIView.transitionWithView(appDelegate.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            appDelegate.window?.rootViewController = controllerNav
            }, completion: nil)
    }

    // @desc: Implements the logic to login to Facebook if the user doesn't currently have a
    //        username or FacebookID registered in the Parse database.
    @IBAction func loginFB(sender: AnyObject) {
        // Set Facebook permissions
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email", "user_friends"],
            block: { (user:PFUser?, error:NSError?) -> Void in
                if(error != nil) {
                    // Display an alert message
                    let myAlert = UIAlertController(title:"Alert", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                    
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                    myAlert.addAction(okAction);
                    self.presentViewController(myAlert, animated: true, completion: nil)
                    
                    return
                }
//                print(user)
//                print("Current user token = \(FBSDKAccessToken.currentAccessToken().tokenString)")
//                print("Current user ID = \(FBSDKAccessToken.currentAccessToken().userID)")
                
                // After registering the Facebook information, redirect page to allow the user
                // to select a username
                self.redirectToNewUserView()
        })
    }
    
    func fetchAllObjects() {
        let query: PFQuery = PFQuery(className: "Battle")
        // query.whereKey("name", equalTo: PFUser.currentUser()!.username!)
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count)  jobs from database.")
                // Do something with the found objects
                if let objects = objects {
                    
                    for object in objects {
                        print(object.objectId)
                        print(object["name"])
                    }
                }
            } else {
                // Log details of the failure
                // println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
}