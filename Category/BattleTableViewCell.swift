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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
