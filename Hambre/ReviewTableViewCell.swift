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
    @IBOutlet var dateCreatedField: UILabel!
    @IBOutlet var reviewStarOne: UIImageView!
    @IBOutlet var reviewStarTwo: UIImageView!
    @IBOutlet var reviewStarThree: UIImageView!
    @IBOutlet var reviewStarFour: UIImageView!
    @IBOutlet var reviewStarFive: UIImageView!
    
    public var averageOfReviews : Float = 0.0
    private var name : String = "Generic name"
    private var comment : String = "A generic comment."
    private var review : Int = 0
    private var dateCreated : String = "01/01/1990"
    
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
    
    public func setStars(averageOfReviews: Float)
    {
        self.averageOfReviews = averageOfReviews
        
        if averageOfReviews == 0.0
        {
            self.reviewStarOne.image = UIImage(named: "graystar")
            self.reviewStarTwo.image = UIImage(named: "graystar")
            self.reviewStarThree.image = UIImage(named: "graystar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if averageOfReviews > 0.0 && averageOfReviews <= 0.5
        {
            
            self.reviewStarOne.image = UIImage(named: "halfstar")
            self.reviewStarTwo.image = UIImage(named: "graystar")
            self.reviewStarThree.image = UIImage(named: "graystar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if averageOfReviews > 0.5 && averageOfReviews <= 1.0
        {
            
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "graystar")
            self.reviewStarThree.image = UIImage(named: "graystar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if averageOfReviews > 1.0 && averageOfReviews <= 1.5
        {
            
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "halfstar")
            self.reviewStarThree.image = UIImage(named: "graystar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if averageOfReviews > 1.5 && averageOfReviews <= 2.0
        {
            
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "graystar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if averageOfReviews > 2.0 && averageOfReviews <= 2.5
        {
            
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "halfstar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if averageOfReviews > 2.5 && averageOfReviews <= 3.0
        {
            
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "fullstar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if averageOfReviews > 3.0 && averageOfReviews <= 3.5
        {
            
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "fullstar")
            self.reviewStarFour.image = UIImage(named: "halfstar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if averageOfReviews > 3.5 && averageOfReviews <= 4.0
        {
            
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "fullstar")
            self.reviewStarFour.image = UIImage(named: "fullstar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if averageOfReviews > 4.0 && averageOfReviews <= 4.5
        {
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "fullstar")
            self.reviewStarFour.image = UIImage(named: "fullstar")
            self.reviewStarFive.image = UIImage(named: "halfstar")
        }
        else if averageOfReviews > 4.5
        {
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "fullstar")
            self.reviewStarFour.image = UIImage(named: "fullstar")
            self.reviewStarFive.image = UIImage(named: "fullstar")
        }
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
