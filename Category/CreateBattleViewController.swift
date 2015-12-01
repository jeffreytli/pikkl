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
    
    @IBOutlet weak var segControlLength: UISegmentedControl!
    
    var friendIDs = [String]()
    var friendNames = [String]()
    var battlePhaseLength = 60
    
    var battleTitles = ["Cool Socks", "Architecture", "Patterns", "Fail", "#Selfie", "Shadows", "Embarrassing", "Cute Dogs", "Cute Cats", "#Flawless", "2015", "Nature", "Drunk Face", "Duck Face", "Ugliest Person", "Food", "Stupid Animals", "Campus Life", "FML", "#Drunk", "Alcohol", "LOL", "Worst Friends", "Basic", "Sexy","#MomTexts", "#WorstGift", "Weirdo", "#Gross", "#Single", "#GymProbs", "#Fabulous", "Beautiful", "#TrueLove", "Love Sucks", "#BFProbs", "GFProbs", "Screwed", "Bad Luck", "Best Shit", "Ugly Cat", "Ugly Dog", "#Bored", "Scenic", "Abstract", "Urban Art", "Street", "Flower", "Portrait", "Landscape", "Deep", "Inception","Children", "Urban", "Rural", "Fashion", "Travel", "Action", "Night", "Night Life", "Dawn", "Dusk", "Insect", "Cars", "Family", "Pets", "Funny", "Wedding", "Mature", "Texture", "Vintage", "Concert", "Music", "Classic", "Frat Life", "Cute", "Shredding", "Happy", "#swag", "Belieber", "ThrowBack", "Light", "Fire"]
    var chosenTitles = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFieldTitle.delegate = self
        
        configureNavView()
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
    
    func buttonTapped(sender:UIButton!) -> Void {
        txtFieldTitle.text = (sender.titleLabel?.text)!
    }
    
    func setButtonDetails(button: UIButton!) -> Void {
        button.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        button.setTitle(getRandomButtonTitle(), forState: UIControlState.Normal)
    }
    
    func getRandomButtonTitle() -> String {
        var index = Int(arc4random_uniform(UInt32(battleTitles.count)))
        
        while(chosenTitles.contains(index)){
            index = Int(arc4random_uniform(UInt32(battleTitles.count)))
        }
        
        chosenTitles.append(index)
        
        return battleTitles[index]
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
        
        chosenTitles.removeAll()
    }
    
    @IBAction func segControlChanged(sender: UISegmentedControl) {
        switch segControlLength.selectedSegmentIndex {
            case 0:
                battlePhaseLength = 60 //default is 2 minutes
            case 1:
                battlePhaseLength = 240 //default is 2 minutes
            default:
                battlePhaseLength = 60 //default is 2 minutes
        }
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
        var battle = PFObject(className:"Battle")
        
        battle = setBattleDetails(battle)
        
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
    
    func setBattleDetails(battle: PFObject) -> PFObject {
        let entryArr:[PFObject] = []
        
        battle["name"] = txtFieldTitle.text
        battle["creator"] = PFUser.currentUser()
        battle["entries"] = entryArr
        battle["time"] = NSDate()
        battle["phaseLength"] = battlePhaseLength
        
        return battle
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
    
    func configureNavView() {
        // Change the font and size of nav bar text
        if let navBarFont = UIFont(name: "GothamBlack", size: 26.0) {
            let navBarAttributesDictionary: [String: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: navBarFont
            ]
            navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        }
        let createBlue = UIColor(red:0/255, green:102/255, blue:255/255, alpha:1.0)
        navigationController?.navigationBar.barTintColor = createBlue as UIColor
    }
}
