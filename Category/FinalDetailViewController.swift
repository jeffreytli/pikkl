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
    
    var currentEntry:PFObject? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userImageFile = currentEntry!["image"] as! PFFile
        
        self.activityIndicator.transform = CGAffineTransformMakeScale(2, 2)
        self.activityIndicator.startAnimating()
        
        userImageFile.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    self.imgEntry.image = image
                }
            }
        }
        self.activityIndicator.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
