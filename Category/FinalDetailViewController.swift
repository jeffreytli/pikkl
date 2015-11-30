//
//  FinalDetailViewController.swift
//  pikkl
//
//  Created by Julio Correa on 11/9/15.
//  Copyright © 2015 CS378. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Parse
import ParseFacebookUtilsV4
import CoreData

class FinalDetailViewController: UIViewController {
    
    @IBOutlet weak var imgEntry: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var barBtnSave: UIBarButtonItem!
    
    @IBOutlet weak var lblFinalScore: UILabel!
    @IBOutlet weak var lblRawScore: UILabel!
    @IBOutlet weak var lblNumVoters: UILabel!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblBattleTitle: UILabel!
    
    var currentEntry:PFObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.transform = CGAffineTransformMakeScale(2, 2)
        setSubmissionLabels()
        setSubmissionImage()
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
    
    func setSubmissionLabels() -> Void {
        lblBattleTitle.text = currentEntry!["battleName"] as? String
        lblUser.text = currentEntry!["ownerName"] as? String
        if(currentEntry!["avgScore"] != nil) {
            lblFinalScore.text = "score: " + String(currentEntry!["avgScore"] as! Double) + "/5.0"
        }
        lblRawScore.text = "raw: " + String(currentEntry!["score"] as! Int)
        lblNumVoters.text = "voted: " + String(currentEntry!["numVoters"] as! Int)
    }
    
    func setSubmissionImage() -> Void {
        self.activityIndicator.startAnimating()
        let userImageFile = currentEntry!["image"] as! PFFile
        
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    self.imgEntry.contentMode = .ScaleToFill
                    self.imgEntry.image = image
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    @IBAction func btnSaveTapped(sender: UIBarButtonItem) {
        UIImageWriteToSavedPhotosAlbum(imgEntry.image!, self, "saveImage:didFinishSavingWithError:contextInfo:", nil)
    }
    
    func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
}
