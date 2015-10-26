//
//  CreateBattleViewController.swift
//  Category
//
//  Created by Julio Correa on 10/14/15.
//  Copyright © 2015 CS378. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Parse
import ParseFacebookUtilsV4

class CreateBattleViewController: UIViewController {

    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var txtFieldTitle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFacebookFriends()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnCancelTapped(sender: AnyObject) {
        redirectToBattlesTableView()
    }
    
    @IBAction func btnDoneTapped(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            let battleName = self.txtFieldTitle.text
            
            let alertController = UIAlertController(title: "Create '" + battleName! + "' Battle", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
                (action:UIAlertAction) in
                // Save to Parse database and return to previous view
                self.navigationController?.popViewControllerAnimated(true)
                
                self.createBattle()
                
                self.redirectToBattlesTableView()
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default){
                (action:UIAlertAction) in
                // Do nothing
            }
            
            alertController.addAction(OKAction)
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion:nil)
        }
    }
    
    func createBattle() -> Void {
        // create battle object
        let battle = PFObject(className:"Battle")
        
        battle["name"] = txtFieldTitle.text
        battle["creator"] = PFUser.currentUser()
        // people invited to battle
        // time left in battle
        
        battle.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
    }
    
    func getFacebookFriends() -> Void {
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil);
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error == nil {
                print("Friends are : \(result)")
            } else {
                print("Error Getting Friends \(error)");
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
        
//        appDelegate.window?.rootViewController = controllerNav
    }
}
