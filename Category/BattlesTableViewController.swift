//
//  BattlesViewController.swift
//  Category
//
//  Created by Julio Correa on 10/14/15.
//  Copyright © 2015 CS378. All rights reserved.
//

import UIKit

class BattlesTableViewController: UITableViewController {

    let textCellIdentifier = "BattleCell"

    let battleCategories = ["#UgliestFriends", "#DrunkMoments", "#WorstGiftEver", "#MySuperPowers", "#WhyImSingle", "#Embarrsssinggggg", "#LemmeTakeASelfie", "#WorstRoommateAward", "#WorstPictureEver", "#ImStupid", "#BestCaption", "#Blessed", "#IHateLife"]
    
//    @IBOutlet weak var battlesTableView: UITableView!
    
    @IBOutlet weak var battlesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:  UITextFieldDelegate Methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return battleCategories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let cell: BattleTableViewCell = tableView.dequeueReusableCellWithIdentifier("BattleCell") as! BattleTableViewCell
        let row = indexPath.row
        cell.lblBattleName.text = battleCategories[row];

        //cell.textLabel?.text = battleCategories[row];
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(battleCategories[row])
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
