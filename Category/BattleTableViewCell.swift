//
//  BattleTableViewCell.swift
//  Category
//
//  Created by Julio Correa on 10/18/15.
//  Copyright © 2015 CS378. All rights reserved.
//

import UIKit

class BattleTableViewCell: UITableViewCell {

    @IBOutlet weak var lblBattleName: UILabel!
    @IBOutlet weak var lblTimeLeft: UILabel!
    @IBOutlet weak var imgViewIconOne: UIImageView!
    @IBOutlet weak var imgViewIconTwo: UIImageView!
    @IBOutlet weak var imgViewIconThree: UIImageView!
    @IBOutlet weak var imgViewIconFour: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        setIcons()
    }
    
    func setIcons(){
        var icon1 = Int(arc4random_uniform(UInt32(10)) + 1)
        var icon2 = Int(arc4random_uniform(UInt32(10)) + 1)
        var icon3 = Int(arc4random_uniform(UInt32(10)) + 1)
        
        while (icon1 == icon2 || icon2 == icon3 || icon1 == icon3){
            icon1 = Int(arc4random_uniform(UInt32(10)) + 1)
            icon2 = Int(arc4random_uniform(UInt32(10)) + 1)
            icon3 = Int(arc4random_uniform(UInt32(10)) + 1)
        }
        
        let index1 = String(icon1)
//        print(index1)
        let index2 = String(icon2)
//        print(index2)
        let index3 = String(icon3)
//        print(index3)
        
        imgViewIconOne.image = UIImage(named: "temp" + index1)
        imgViewIconTwo.image = UIImage(named: "temp" + index2)
        imgViewIconThree.image = UIImage(named: "temp" + index3)
        imgViewIconFour.hidden = true
    }
}
