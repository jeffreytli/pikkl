//
//  VoteTableViewController.swift
//  pikkl
//
//  Created by Julio Correa on 11/7/15.
//  Copyright © 2015 CS378. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Parse
import ParseFacebookUtilsV4
import CoreData

class VoteTableViewController: UITableViewController {
    var battleTitle:String = ""
    var battleId:String = ""
    var entries:[PFObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
     
        tableView.separatorColor = UIColor.redColor()
        
        fetchAllBattleEntries()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.redColor()
        cell.textLabel!.font = UIFont (name: "GothamBold", size: 15)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VoteCell", forIndexPath: indexPath)

        let row = indexPath.row
        
        //if(entries.count > row-1 )
        //print(String(row) + "this is row")
        //print(String(entries.count) + "this is entry count")
        cell.textLabel!.text = (entries[row]["ownerName"] as? String)! + "'s Pik"

        return cell
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "VoteDetail" {
            let indexPath:NSIndexPath? = self.tableView!.indexPathForSelectedRow
            
            // Get the destination view controller
            let voteDetail:VoteForEntryViewController = segue.destinationViewController as! VoteForEntryViewController

            // Pass in the title for the row selected
            voteDetail.currentEntry = entries[indexPath!.row]
        }
    }
}
