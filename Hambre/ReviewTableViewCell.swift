//
//  ReviewTableViewCell.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/6/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var commentField: UITextView!
    @IBOutlet weak var reviewField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
