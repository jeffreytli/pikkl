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

//will be used to determine which segues need to be triggered
enum Stage {
    case SUBMIT
    case VOTE
    case FINAL
}

class BattlesTableViewController: UITableViewController {
    
    let textCellIdentifier = "BattleCell"
    
    var data:BattleDataModel? = nil
    var battles = [NSManagedObject]()
    var currentStage = Stage.VOTE
    
    @IBOutlet weak var battlesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = BattleDataModel()
        battles = (data?.getBattles())!
        
        fetchAllObjects()
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
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        let row = indexPath.row
        
        
        if(currentStage == Stage.SUBMIT) {
            self.performSegueWithIdentifier("Submit", sender: indexPath)
        } else if(currentStage == Stage.VOTE) {
            self.performSegueWithIdentifier("Vote", sender: indexPath)
        } else if(currentStage == Stage.FINAL) {
            self.performSegueWithIdentifier("Final", sender: indexPath)
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
    
    func fetchAllObjects() {
        let query: PFQuery = PFQuery(className: "Battle")
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count)  jobs from database.")
                // Do something with the found objects
                if let objects = objects {
                    
                    for object in objects {
                        print("ObjectId: " + ((object.objectId)! as String))
                        print("BattleName: " + ((object["name"])! as! String))
                        
                        // Save new objects into core data
                        self.data!.saveBattle(object.objectId!, name: object["name"] as! String)
                        
                        // TODO: Fix this, this is super hard-codey
                        self.battles = (self.data?.getBattles())!
                        
                        self.tableView.reloadData()
                    }
                }
            } else {
//                 Log details of the failure
                 print("Error: \(error!)")
            }
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

    }
}
