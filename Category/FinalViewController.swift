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
    
    @IBOutlet weak var lblBattleTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblBattleTitle.text = battleTitle
        fetchAllBattleEntries()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "voteCell")
        tableView.delegate = self
        tableView.dataSource = self
        //self.tableView.reloadData()
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
        query.orderByDescending("score")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count)  jobs from database.")
                // Do something with the found objects
                if let objects = objects {
                    
                    for object in objects {
                        print("ObjectId: " + ((object.objectId)! as String))
                        self.entries.append(object)
                    }
                    self.tableView.reloadData()
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
        //because first index is being displayed at top
        return entries.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0) {
            return 139
        } else {
            return 57
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        if(row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("FinalWinnerCell", forIndexPath: indexPath) as! FinalTableViewCell
            cell.lblUser.text = (entries[row]["ownerName"] as? String)!
            if(entries[row]["avgScore"] != nil) {
                cell.lblScore.text = "Avg: " + String((entries[row]["avgScore"] as! Double)) + "/5.0"
            }
            cell.lblRaw.text = "Raw: " + String((entries[row]["score"] as! Int))
            cell.lblVoted.text = "Voted " + String((entries[row]["numVoters"] as! Int))
            
            let userImageFile = entries[row]["thumbnail"] as! PFFile
            
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        cell.imgPreview.image = image
                    }
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("FinalCell", forIndexPath: indexPath)
            
            var finalScore:Double = -1.0

            //because first index is being displayed at top
            if(entries[row]["avgScore"] != nil) {
                finalScore = entries[row]["avgScore"] as! Double
            }
            
            setCellText(row, cell: cell, finalScore: finalScore)
            
            return cell
        } 
    }
    
    func setCellText(row: Int, cell: UITableViewCell, finalScore: Double) -> Void {
        let cellOwnerId:String = (entries[row]["owner"] as! PFUser).valueForKey("objectId")! as! String
        let curUserId:String = PFUser.currentUser()!.valueForKey("objectId")! as! String
        
        if(cellOwnerId  == curUserId) {
            cell.textLabel!.text = "My Submission"
            cell.backgroundColor = UIColor(red: 0.60, green: 0.92, blue: 0.71, alpha: 0.8)
        } else {
            cell.textLabel!.text = (entries[row]["ownerName"] as? String)! + "'s Submission"
        }
        
        cell.detailTextLabel!.text = String(finalScore) + "/5.0"
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
