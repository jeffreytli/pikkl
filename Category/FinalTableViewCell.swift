//
//  FinalTableViewCell.swift
//  pikkl
//
//  Created by Julio Correa on 11/28/15.
//  Copyright © 2015 CS378. All rights reserved.
//

import UIKit

class FinalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgPreview: UIImageView!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblRaw: UILabel!
    @IBOutlet weak var lblVoted: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
