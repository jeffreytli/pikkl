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
import CoreData

class CreateBattleViewController: UIViewController, UITextFieldDelegate {
    
    enum Stage: Int {
        case SUBMIT = 1
        case VOTE = 2
        case FINAL = 3
    }

    @IBOutlet weak var txtFieldTitle: UITextField!

    @IBOutlet weak var btnOne: UIButton!
    @IBOutlet weak var btnTwo: UIButton!
    @IBOutlet weak var btnThree: UIButton!
    @IBOutlet weak var btnFour: UIButton!
    @IBOutlet weak var btnFive: UIButton!
    @IBOutlet weak var btnSix: UIButton!
    @IBOutlet weak var btnSeven: UIButton!
    @IBOutlet weak var btnEight: UIButton!
    @IBOutlet weak var btnNine: UIButton!
    @IBOutlet weak var btnTen: UIButton!
    @IBOutlet weak var btnEleven: UIButton!
    @IBOutlet weak var btnTwelve: UIButton!
    
    @IBOutlet weak var btnCreate: UIButton!
    
    var friendIDs = [String]()
    var friendNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getFacebookFriends()
        
        txtFieldTitle.delegate = self
        
        setAllButtonDetails()
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
    
    @IBAction func btnInviteFriends(sender: AnyObject) {
        getFacebookFriends()
    }
    
    func buttonTapped(sender:UIButton!) -> String {
        txtFieldTitle.text = (sender.titleLabel?.text)!
        print((sender.titleLabel?.text)!)
        return ""
    }
    
    func setButtonDetails(button: UIButton!) -> Void {
        button.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func setAllButtonDetails() -> Void {
        setButtonDetails(btnOne!)
        setButtonDetails(btnTwo!)
        setButtonDetails(btnThree!)
        setButtonDetails(btnFour!)
        setButtonDetails(btnFive!)
        setButtonDetails(btnSix!)
        setButtonDetails(btnSeven!)
        setButtonDetails(btnEight!)
        setButtonDetails(btnNine!)
        setButtonDetails(btnTen!)
        setButtonDetails(btnEleven!)
        setButtonDetails(btnTwelve!)
    }
    
    @IBAction func btnCreateTapped(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue()) {
            let battleName = self.txtFieldTitle.text
            
            if (!battleName!.isEmpty){
                self.displayValidBattlePrompt(battleName!)
            } else {
                self.displayInvalidBattlePrompt()
            }
        }
    }
    
    func displayValidBattlePrompt(battleName: String) -> Void {
        let alertController = UIAlertController(title: "Create \"" + battleName + "\"", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
            (action:UIAlertAction) in
            // Save to Parse database and return to previous view
            self.navigationController?.popViewControllerAnimated(true)
            
            self.createBattle()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default){
            (action:UIAlertAction) in
            // Do nothing
        }
        
        alertController.addAction(OKAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
    }
    
    func displayInvalidBattlePrompt() -> Void {
        let alertController = UIAlertController(title: "", message:
            "Please enter a battle name", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func createBattle() -> Void {
        let battle = PFObject(className:"Battle")
        let date = NSDate()
        
        let entryArr:[PFObject] = []
        battle["name"] = txtFieldTitle.text
        battle["creator"] = PFUser.currentUser()
        battle["entries"] = entryArr
        battle["time"] = date
        //battle["phaseLength"] = Int(datePickerCountDown.countDownDuration)
        
        battle.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                sleep(1)
                self.redirectToBattlesTableView()
            } else {
                print("Error in saving battle")
            }
        }
    }
    
    // Currently unused
    func getFacebookFriends() -> Void {
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: nil);
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error == nil {
                print("Friends are : \(result)")
                let friendObjects = result["data"] as! [NSDictionary]
                for friendObject in friendObjects {
                    let friendID = friendObject["id"] as! NSString
                    let friendName = friendObject["name"] as! NSString
                    
                    self.friendIDs.append(friendID as String)
                    self.friendNames.append(friendName as String)
                    
                    print(friendObject["id"] as! NSString)
                    print(friendObject["name"] as! NSString)
                }
                print("\(friendObjects.count)")
            } else {
                print("Error Getting Friends \(error)");
            }
        }
    }
    
    @IBAction func btnCancelTapped(sender: AnyObject) {
        redirectToBattlesTableView()
    }
    
    func redirectToBattlesTableView() -> Void {
        textFieldShouldReturn(txtFieldTitle) // hide the keyboard
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        
        let controller = storyboard.instantiateViewControllerWithIdentifier("BattlesTableViewController") as! BattlesTableViewController
        
        let controllerNav = UINavigationController(rootViewController: controller)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        UIView.transitionWithView(appDelegate.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            appDelegate.window?.rootViewController = controllerNav
            }, completion: nil)
    }
    
    // Makes keyboard go away when you touch Return key on keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        txtFieldTitle.resignFirstResponder()
        return true;
    }
    
    // Makes keyboard go away when you touch outside of the keyboard area
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        txtFieldTitle.resignFirstResponder()
        self.view.endEditing(true)
    }
}
