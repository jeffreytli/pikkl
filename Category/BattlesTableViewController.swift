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
    
    let PHASE_INTERVAL = 3600.0 // This is currently set to 1 hour; each phase is an hour long
    
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
        // Dispose of any resources that can be recreated.
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
        cell.lblCurrentPhase.text = "Current Phase: " + (battle.valueForKey("currentPhase") as? String)!
        cell.lblTimeLeft.text = "Time Left: " + (battle.valueForKey("timeLeft") as? String)! + "m"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        
        let battle = battles[row]
        
        //currentStage = getCurrentPhase((battle.valueForKey("currentPhase") as? String)!)
        
        currentStage = Phase.VOTE
        
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
        if (currentPhase == "1"){
            return Phase.SUBMIT
        } else if (currentPhase == "2"){
            return Phase.VOTE
        } else {
            return Phase.FINAL
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
    
    // @desc: Makes a query to our Parse database and pulls all Battle objects
    func fetchAllBattles() {
        let query: PFQuery = PFQuery(className: "Battle")
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count)  jobs from database.")

                // Do something with the found objects
                if let objects = objects {
                    
                    for object in objects {
                        //print("ObjectId: " + ((object.objectId)! as String))
                        //print("BattleName: " + ((object["name"])! as! String))
                        
                        let timeCreated = (object["time"])!
                        let intervalInSeconds = NSDate().timeIntervalSinceDate(timeCreated as! NSDate)
                        //print(intervalInSeconds/self.PHASE_INTERVAL)
                        
                        let currentPhase = self.getCurrentPhase(intervalInSeconds/self.PHASE_INTERVAL)
                        let timeLeft = self.getTimeLeft(intervalInSeconds/self.PHASE_INTERVAL)
                        //print("Time left: " + timeLeft + "m")
                        
                        // Save new objects into core data
                        self.data!.saveBattle(object.objectId!, name: object["name"] as! String, currentPhase: currentPhase, timeLeft: timeLeft)
                        
                        self.battles = (self.data?.getBattles())!
                        
                        self.tableView.reloadData()
                    }
                }
            } else {
                 // Log details of the failure
                 print("Error: \(error!)")
            }
        }
    }
    
    // @desc: Based off of the elapsed time since the creation of the battle,
    //        determine which phase the battle is in.
    func getCurrentPhase(timeInterval: Double) -> String {
        if (timeInterval < 1){
            return "Submit"
        } else if (timeInterval >= 1 && timeInterval < 2){
            return "Voting"
        } else {
            return "Final"
        }
    }
    
    // @desc: Get the remaining time left in each phase of the battle.
    func getTimeLeft(timeInterval: Double) -> String {
        var timeLeft = 0.0
        
        if (timeInterval < 1.0){
            timeLeft = timeInterval * PHASE_INTERVAL
            timeLeft = timeLeft / 60.0
            return String(Int(timeLeft))
        } else if (timeInterval >= 1.0 && timeInterval < 2.0){
            timeLeft = timeInterval - 1.0
            timeLeft = timeLeft * PHASE_INTERVAL
            timeLeft = timeLeft / 60.0
            return String(Int(timeLeft))
        } else {
            return "0"
        }
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
            let voteVC:VoteTableViewController = segue.destinationViewController as! VoteTableViewController
            
            // Pass in the title for the row selected
            voteVC.battleTitle = currentCell.lblBattleName.text!
            voteVC.battleId = (battles[indexPath.row].valueForKey("objectId") as? String)!
        }
        
        if segue.identifier == "Final" {
            
            let indexPath:NSIndexPath = sender as! NSIndexPath
            let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! BattleTableViewCell!;
            
            // Get the destination view controller
            let finalVC:FinalTableViewController = segue.destinationViewController as! FinalTableViewController
            
            // Pass in the title for the row selected
            finalVC.battleTitle = currentCell.lblBattleName.text!
            finalVC.battleId = (battles[indexPath.row].valueForKey("objectId") as? String)!
        }
    }
}
