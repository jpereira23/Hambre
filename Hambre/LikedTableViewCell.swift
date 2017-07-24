//
//  LikedTableViewCell.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/5/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class LikedTableViewCell: UITableViewCell {

    @IBOutlet weak var distanceField: UILabel!
    @IBOutlet weak var theImageView: UIImageView!
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet var amountOfReviewsField: UILabel!
    @IBOutlet var reviewStarOne: UIImageView!
    @IBOutlet var reviewStarTwo: UIImageView!
    @IBOutlet var reviewStarThree: UIImageView!
    @IBOutlet var reviewStarFour: UIImageView!
    @IBOutlet var reviewStarFive: UIImageView!
    
    
    private var theTitle = "A REVIEW."
    private var theDistance = "Infinite miles"
    private var theAmountOfReviews = "0 reviews"
    private var averageOfReviews : Float = 0.0
    
    
    private var theImage : UIImage!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setImage(image: UIImage)
    {
        self.theImageView.image = image
        self.theImageView.contentMode = UIViewContentMode.scaleToFill
    }
    
    public func setTitle(title: String)
    {
        self.theTitle = title
    }
    
    public func setAverageReview(averageReview: Float)
    {
        self.averageOfReviews = averageReview
        
        if averageReview == 0.0
        {
            self.reviewStarOne.image = UIImage(named: "graystar")
            self.reviewStarTwo.image = UIImage(named: "graystar")
            self.reviewStarThree.image = UIImage(named: "graystar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if averageReview > 0.0 && averageReview <= 0.5
        {
            self.reviewStarOne.image = UIImage(named: "halfstar")
            self.reviewStarTwo.image = UIImage(named: "graystar")
            self.reviewStarThree.image = UIImage(named: "graystar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if averageReview > 0.5 && averageReview <= 1.0
        {
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "graystar")
            self.reviewStarThree.image = UIImage(named: "graystar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if averageReview > 1.0 && averageReview <= 1.5
        {
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "halfstar")
            self.reviewStarThree.image = UIImage(named: "graystar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if averageReview > 1.5 && averageReview <= 2.0
        {
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "graystar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if averageReview > 2.0 && averageReview <= 2.5
        {
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "halfstar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if averageReview > 2.5 && averageReview <= 3.0
        {
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "fullstar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if averageReview > 3.0 && averageReview <= 3.5
        {
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "fullstar")
            self.reviewStarFour.image = UIImage(named: "halfstar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if averageReview > 3.5 && averageReview <= 4.0
        {
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "fullstar")
            self.reviewStarFour.image = UIImage(named: "fullstar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if averageReview > 4.0 && averageReview <= 4.5
        {
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "fullstar")
            self.reviewStarFour.image = UIImage(named: "fullstar")
            self.reviewStarFive.image = UIImage(named: "halfstar")
        }
        else if averageReview > 4.5
        {
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "fullstar")
            self.reviewStarFour.image = UIImage(named: "fullstar")
            self.reviewStarFive.image = UIImage(named: "fullstar")
        }
        
    }
    
    public func setDistance(distance: String)
    {
        self.theDistance = distance
    }
    
    public func setAmountOfReviews(reviewsAmount: String)
    {
        self.theAmountOfReviews = reviewsAmount 
    }

}
