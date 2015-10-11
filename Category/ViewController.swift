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

class ViewController: UIViewController {

    @IBOutlet weak var btnFBLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func loginFB(sender: AnyObject) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email"], block: { (user:PFUser?, error:NSError?) -> Void in
            if(error != nil) {
                //TODO display an alert message (from youtube vid)
                print("ERROR!!")
            }
            print(user)
            print("Current user token = \(FBSDKAccessToken.currentAccessToken().tokenString)")
            print("Current user ID = \(FBSDKAccessToken.currentAccessToken().userID)")
            
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

