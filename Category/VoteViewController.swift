//
//  VoteViewController.swift
//  pikkl
//
//  Created by Julio Correa on 11/22/15.
//  Copyright © 2015 CS378. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Parse
import ParseFacebookUtilsV4
import CoreData

class VoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var battleTitle:String = ""
    var battleId:String = ""
    var entries:[PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllBattleEntries()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "voteCell")
        tableView.delegate = self
        tableView.dataSource = self
        //self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("voteCell", forIndexPath: indexPath)
        let row = indexPath.row
        cell.textLabel!.text = (entries[row]["ownerName"] as? String)! + "'s Submission"
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("VoteDetail", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


    // MARK: - Navigation
    
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
