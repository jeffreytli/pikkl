//
//  BattlesViewController.swift
//  Category
//
//  Created by Julio Correa on 10/14/15.
//  Copyright © 2015 CS378. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseFacebookUtilsV4

class BattlesTableViewController: UITableViewController  {

    let textCellIdentifier = "BattleCell"
    
    var battleIDs:[String] = []
    
//    @IBOutlet weak var battlesTableView: UITableView!
    
    @IBOutlet weak var battlesTableView: UITableView!
    
    override func viewDidLoad() {
        self.fetchAllObjects()
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(String(battleIDs.count))
        
        return battleIDs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        print(String(battleIDs.count))
        
        
        let cell: BattleTableViewCell = tableView.dequeueReusableCellWithIdentifier("BattleCell") as! BattleTableViewCell
        let row = indexPath.row
        var query:PFQuery = PFQuery(className: "Battle")
        //query = query.whereKey("objectId", equalTo: battleIDs[row])
        
       // query.limit = 1
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("WAZZAP")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        cell.lblBattleName?.text = object["name"] as! String;
                    }
                }
            } else {
                // Log details of the failure
                 print("Error: \(error!)")
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
      //  print(battleCategories[row])
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
       // query.whereKey("name", equalTo: PFUser.currentUser()!.username!)
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count)  jobs from database.")
                // Do something with the found objects
                if let objects = objects {
         
                    for object in objects {
                        print(object.objectId)
                        print(object["name"])
                        self.battleIDs.append(object.objectId! as String)
                    }
                }
            } else {
                // Log details of the failure
               // println("Error: \(error!) \(error!.userInfo!)")
            }   
        }
    }
}
