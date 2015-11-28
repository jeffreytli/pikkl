//
//  BattlesViewController.swift
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

// @desc: Will be used to determine which segues need to be triggered
enum Phase {
    case SUBMIT
    case VOTE
    case FINAL
}

class BattlesTableViewController: UITableViewController {
    
    let textCellIdentifier = "BattleCell"
    
    var data:BattleDataModel? = nil
    var currentStage = Phase.VOTE
    var battles = [NSManagedObject]()
    
    @IBOutlet weak var battlesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        data = BattleDataModel()
        battles = (data?.getBattles())!
        
        fetchAllBattles()
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    // @desc: Defines user swipe refresh functionality
    func refresh(sender:AnyObject){
        fetchAllBattles()
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    // @desc: Prevents landscape mode
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (data?.getBattlesCount())!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: BattleTableViewCell = tableView.dequeueReusableCellWithIdentifier("BattleCell") as! BattleTableViewCell
        let row = indexPath.row
        let battle = battles[row]
        
        cell.lblBattleName.text = (battle.valueForKey("name") as? String)!
        cell.lblCurrentPhase.text = (battle.valueForKey("currentPhase") as? String)!
        setPhaseTextColor(cell)
        
        cell.lblTimeLeft.text = (battle.valueForKey("timeLeft") as? String)! + "m"
        
        return cell
    }
    
    func setPhaseTextColor(cell: BattleTableViewCell) -> Void {
        if (cell.lblCurrentPhase.text == "Vote"){ //Purple
            cell.lblCurrentPhase.textColor = UIColor(red: 158.0/255.0, green: 126.0/255.0, blue: 241.0/255.0, alpha: 1.0)
            cell.lblTimeLeft.textColor = UIColor(red: 158.0/255.0, green: 126.0/255.0, blue: 241.0/255.0, alpha: 1.0)
            cell.lblCurrentPhase.text = "vote"
        } else if (cell.lblCurrentPhase.text == "Final") { //Red
            cell.lblCurrentPhase.textColor = UIColor(red: 252.0/255.0, green: 78.0/255.0, blue: 44.0/255.0, alpha: 1.0)
            cell.lblTimeLeft.textColor = UIColor(red: 252.0/255.0, green: 78.0/255.0, blue: 44.0/255.0, alpha: 1.0)
            cell.lblCurrentPhase.text = "scores"
        } else { //Green
            cell.lblCurrentPhase.textColor = UIColor(red: 22.0/255.0, green: 219.0/255.0, blue: 106.0/255.0, alpha: 1.0)
            cell.lblTimeLeft.textColor = UIColor(red: 22.0/255.0, green: 219.0/255.0, blue: 106.0/255.0, alpha: 1.0)
            cell.lblCurrentPhase.text = "join"
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        let battle = battles[row]
        
        currentStage = getCurrentPhase((battle.valueForKey("currentPhase") as? String)!)
                        
        if(currentStage == Phase.SUBMIT) {
            self.performSegueWithIdentifier("Submit", sender: indexPath)
        } else if(currentStage == Phase.VOTE) {
            self.performSegueWithIdentifier("Vote", sender: indexPath)
        } else if(currentStage == Phase.FINAL) {
            self.performSegueWithIdentifier("Final", sender: indexPath)
        }
    }
    
    // @desc: Helper function to get the current phase of the battle
    func getCurrentPhase(currentPhase: String) -> Phase {
        if (currentPhase == "Submit"){
            return Phase.SUBMIT
        } else if (currentPhase == "Vote"){
            return Phase.VOTE
        } else {
            return Phase.FINAL
        }
    }
    
    // @desc: Makes a query to our Parse database and pulls all Battle objects
    func fetchAllBattles() {
        let query: PFQuery = PFQuery(className: "Battle")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count)  jobs from database.")

                // Do something with the found objects
                if let objects = objects {
                    self.processBattleObjects(objects)
                }
            } else {
                 // Log details of the failure
                 print("Error: \(error!)")
            }
        }
    }
    
    func processBattleObjects(objects: [PFObject]?) -> Void {
        for object in objects! {
            print("ObjectId: " + self.getBattleObjectId(object))
            print("BattleName: " + self.getBattleName(object))
            
            let curPhaseLength = self.getBattlePhaseLength(object)
            print("Phase Length: " + String(curPhaseLength))
            
            let timeCreated = self.getBattleTimeCreated(object)
            let timeElapsed = self.getTimeElapsed(curPhaseLength, timeCreated: timeCreated)
            print("Time Elapsed: " + String(timeElapsed))
            
            let currentPhase = self.getCurrentPhase(timeElapsed)
            let timeLeft = self.getTimeLeft(timeElapsed, phaseLength: curPhaseLength)
            print("Time left: " + timeLeft + "m")
            
            // Save new objects into core data
            self.data!.saveBattle(object.objectId!, name: object["name"] as! String, currentPhase: currentPhase, timeLeft: timeLeft)
            
            self.battles = (self.data?.getBattles())!
            
            self.tableView.reloadData()
        }
    }
    
    // Get time elapsed in minutes
    func getTimeElapsed(curPhaseLength: Double, timeCreated: AnyObject) -> NSTimeInterval{
        return NSDate().timeIntervalSinceDate(timeCreated as! NSDate) / curPhaseLength
    }
    
    func getBattleTimeCreated(object: PFObject) -> AnyObject {
        return object["time"]
    }
    
    func getBattlePhaseLength(object: PFObject) -> Double {
        return Double(object["phaseLength"].integerValue)
    }
    
    func getBattleName(object: PFObject) -> String {
        return object["name"]! as! String
    }
    
    func getBattleObjectId(object: PFObject) -> String {
        return object.objectId! as String
    }
    
    // @desc: Based off of the elapsed time since the creation of the battle,
    //        determine which phase the battle is in.
    func getCurrentPhase(timeInterval: Double) -> String {
        if (timeInterval < 1){
            return "Submit"
        } else if (timeInterval >= 1 && timeInterval < 2){
            return "Vote"
        } else {
            return "Final"
        }
    }
    
    // @desc: Get the remaining time left in each phase of the battle.
    func getTimeLeft(timeInterval: Double, phaseLength: Double) -> String {
        var timeLeft = 0.0
        
        if (timeInterval < 1.0){
            timeLeft = timeInterval * phaseLength
            timeLeft = timeLeft / 60.0
            timeLeft = ((phaseLength / 60.0) + 1.0) - timeLeft
            return String(Int(timeLeft))
        } else if (timeInterval >= 1.0 && timeInterval < 2.0){
            timeLeft = timeInterval - 1.0
            timeLeft = timeLeft * phaseLength
            timeLeft = timeLeft / 60.0
            timeLeft = ((phaseLength / 60.0) + 1.0) - timeLeft
            return String(Int(timeLeft))
        } else {
            return "0"
        }
    }
    
    @IBAction func createBattleTapped(sender: AnyObject) {
        redirectToCreateBattleView()
    }
    
    func redirectToCreateBattleView() -> Void {
        let storyboard = UIStoryboard(name: "Create", bundle: nil)
        
        let controller = storyboard.instantiateViewControllerWithIdentifier("CreateBattleViewController") as! CreateBattleViewController
        
        let controllerNav = UINavigationController(rootViewController: controller)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window?.rootViewController?.presentViewController(controllerNav, animated: true, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Do something for the ShowDetail segue
        if segue.identifier == "Submit" {
            
            let indexPath:NSIndexPath = sender as! NSIndexPath
            let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! BattleTableViewCell!;

            // Get the destination view controller
            let detailVC:SubmitViewController = segue.destinationViewController as! SubmitViewController
            
            // Pass in the title for the row selected
            detailVC.battleTitle = currentCell.lblBattleName.text!
            detailVC.battleID = (battles[indexPath.row].valueForKey("objectId") as? String)!
        }
        
        if segue.identifier == "Vote" {
            
            let indexPath:NSIndexPath = sender as! NSIndexPath
            let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! BattleTableViewCell!;
            
            // Get the destination view controller
            let voteVC:VoteViewController = segue.destinationViewController as! VoteViewController
            
            // Pass in the title for the row selected
            voteVC.battleTitle = currentCell.lblBattleName.text!
            voteVC.battleId = (battles[indexPath.row].valueForKey("objectId") as? String)!
        }
        
        if segue.identifier == "Final" {
            
            let indexPath:NSIndexPath = sender as! NSIndexPath
            let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! BattleTableViewCell!;
            
            // Get the destination view controller
            let finalVC:FinalViewController = segue.destinationViewController as! FinalViewController
            
            // Pass in the title for the row selected
            finalVC.battleTitle = currentCell.lblBattleName.text!
            finalVC.battleId = (battles[indexPath.row].valueForKey("objectId") as? String)!
        }
    }
}
