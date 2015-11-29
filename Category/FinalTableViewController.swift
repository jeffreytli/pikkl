//
//  FinalTableViewController.swift
//  pikkl
//
//  Created by Julio Correa on 11/7/15.
//  Copyright © 2015 CS378. All rights reserved.
//

// NOTE: THIS CLASS IS CURRENTLY UNUSED!

import UIKit
import FBSDKLoginKit
import Parse
import ParseFacebookUtilsV4
import CoreData

class FinalTableViewController: UITableViewController {
    
    var battleTitle:String = ""
    var battleId:String = ""
    var entries:[PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAllBattleEntries()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    // @desc: Makes a query to our Parse database and pulls all Battle Entry objects
    func fetchAllBattleEntries() -> Void {
        let query = PFQuery(className:"BattleEntry")
        query.whereKey("battle", equalTo:battleId)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count)  jobs from database.")
                // Do something with the found objects
                if let objects = objects {
                    
                    for object in objects {
                        print("ObjectId: " + ((object.objectId)! as String))
                        
                        self.entries.append(object)
                        self.tableView.reloadData()
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FinalCell", forIndexPath: indexPath)
        
        let row = indexPath.row
        
        let finalScore = getFinalScore(row)
        
        let cellOwnerId:String = (entries[row]["owner"] as! PFUser).valueForKey("objectId")! as! String
        let curUserId:String = PFUser.currentUser()!.valueForKey("objectId")! as! String
        if(cellOwnerId  == curUserId) {
            cell.textLabel!.text = "My Submission"
            cell.backgroundColor = UIColor(red: 0.60, green: 0.92, blue: 0.71, alpha: 0.8)
        } else {
            cell.textLabel!.text = (entries[row]["ownerName"] as? String)! + "'s Submission"
        }
        cell.detailTextLabel!.text = String(finalScore) + "/ 5.0"

        return cell
    }
    
    func getFinalScore(row: Int) -> Double {
        //if(entries.count > row-1 )
        //print(String(row) + "this is row")
        //print(String(entries.count) + "this is entry count")
        let score:Int = entries[row]["score"] as! Int
        let numVoters:Int = entries[row]["numVoters"] as! Int
        
        var finalScore:Double = Double(score) / Double(numVoters)
        
        //to cover the case where 0 people voted, which would result in 0/0 or NaN
        if(finalScore.isNaN) {
            finalScore = 0
        }
        
        return finalScore
    }
    
    func setCellText() -> Void {
        
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "FinalDetail" {
            let indexPath:NSIndexPath? = self.tableView!.indexPathForSelectedRow
            
            // Get the destination view controller
            let voteDetail:FinalDetailViewController = segue.destinationViewController as! FinalDetailViewController
            
            // Pass in the title for the row selected
            voteDetail.currentEntry = entries[indexPath!.row]
        }
    }
}
