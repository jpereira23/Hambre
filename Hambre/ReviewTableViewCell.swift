//
//  ReviewTableViewCell.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/6/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import SystemConfiguration

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var commentField: UILabel!
    @IBOutlet weak var reviewField: UILabel!
    
    private var name : String = "Generic name"
    private var comment : String = "A generic comment."
    private var review : Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //commentField.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.addSubview(nameField)
        self.nameField.text! = name
        //self.commentField.text! = comment
        //self.reviewField.text! = String(review)
        //self.textLabel?.text = name
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setName(name: String)
    {
        self.name = name
    }
    
    public func setComment(comment: String)
    {
        self.comment = comment
    }
    
    public func setReview(review: Int)
    {
        self.review = review
    }
    
    
    
    

}
