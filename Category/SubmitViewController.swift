//
//  SubmitViewController.swift
//  pikkl
//
//  Created by Julio Correa on 10/25/15.
//  Copyright © 2015 CS378. All rights reserved.
//

import UIKit

class SubmitViewController: UIViewController {

    @IBOutlet weak var lblBattleTitle: UILabel!
    
    @IBOutlet weak var imgSubmit: UIImageView!
    
    
    @IBAction func imgTapSubmit(sender: AnyObject) {
        //open camera for image upload
        lblBattleTitle.text! = "tap !!"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imgSubmit.image = UIImage(named: "cameraIcon")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
