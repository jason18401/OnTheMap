//
//  UserListCell.swift
//  On The Map
//
//  Created by Jason Yu on 6/11/20.
//  Copyright © 2020 Jason Yu. All rights reserved.
//

import UIKit

class UserListCell: UITableViewCell {

    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var link: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
