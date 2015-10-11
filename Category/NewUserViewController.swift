//
//  NewUserViewController.swift
//  Category
//
//  Created by Jeffrey Li on 10/11/15.
//  Copyright © 2015 CS378. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4

class NewUserViewController: UIViewController {
    
    @IBOutlet weak var fieldUsername: UITextField!
    @IBOutlet weak var btnSaveUsername: UIButton!
    // user will be set from sending view controller
    var user:PFUser?


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnSaveUsername(sender: AnyObject) {
        user?.username = fieldUsername!.text!
        user?.saveInBackground()
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
