//
//  FinalViewController.swift
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

class FinalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var battleTitle:String = ""
    var battleId:String = ""
    var battlePhotos:[UIImage] = []
    var entries:[PFObject] = []
    @IBOutlet weak var tableView: UITableView!

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
    
    @IBAction func barBtnSaveAllTapped(sender: UIBarButtonItem) {
        saveAllBattlePhotos()
    }
    
    func saveAllBattlePhotos() -> Void {
        for entry in self.entries {
            let userImageFile = entry["image"] as! PFFile
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        UIImageWriteToSavedPhotosAlbum(image!, self, "saveImage:didFinishSavingWithError:contextInfo:", nil)
                    }
                }
            }
        }
    }
    
    func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>){
        if error == nil {
            print("Image save successful")
        } else {
            print("Image save failed")
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FinalCell", forIndexPath: indexPath)
        let row = indexPath.row
        let score:Int = entries[row]["score"] as! Int
        let numVoters:Int = entries[row]["numVoters"] as! Int
        var finalScore:Double = Double(score) / Double(numVoters)
        if(finalScore.isNaN) { //to cover the case where 0 people voted, which would result in 0/0 or NaN
            finalScore = 0
        }
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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FinalDetail" {
            let indexPath:NSIndexPath? = self.tableView!.indexPathForSelectedRow
            tableView.deselectRowAtIndexPath(indexPath!, animated: true)

            
            // Get the destination view controller
            let voteDetail:FinalDetailViewController = segue.destinationViewController as! FinalDetailViewController
            
            // Pass in the title for the row selected
            voteDetail.currentEntry = entries[indexPath!.row]
        }
    }
}
