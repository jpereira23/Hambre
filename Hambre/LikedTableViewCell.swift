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
    
    
    private var theTitle = "A REVIEW."
    private var theDistance = "Infinite miles"
    private var theAmountOfReviews = "0 reviews"
    
    private var theURL : URL!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if self.theURL != nil
        {
         
            self.theImageView.contentMode = UIViewContentMode.scaleToFill
        }
        
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setURL(url: URL)
    {
        self.theURL = url
        self.theImageView.setImageWith(self.theURL)
        self.theImageView.contentMode = UIViewContentMode.scaleToFill
    }
    
    public func setTitle(title: String)
    {
        self.theTitle = title
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
