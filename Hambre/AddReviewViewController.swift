
//
//  AddReviewViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/2/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class AddReviewViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var reviewSlider: UISlider!
    @IBOutlet weak var greetingField: UILabel!
    @IBOutlet weak var commentView: UITextView!
    
    @IBOutlet weak var reviewStarOne: UIButton!
    @IBOutlet weak var reviewStarTwo: UIButton!
    @IBOutlet weak var reviewStarThree: UIButton!
    @IBOutlet weak var reviewStarFour: UIButton!
    @IBOutlet weak var reviewStarFive: UIButton!
    
 
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        reviewSlider.maximumValue = 5
        reviewSlider.minimumValue = 0
        reviewSlider.setValue(0.0, animated: animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.greetingField.text = "By: " + appDelegate.accessICloudName()
        
        // Do any additional setup after loading the view.
        
        self.title = "Review"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightBold), NSForegroundColorAttributeName: UIColor.white]
        
        commentView.delegate = self
        self.commentView.text = "Example: This has got to be my favorite burger place! Every time I come here, the customer service and quality of food never disappoint. I'm a huge burger fan, so my patties, fries, and bacon all have to be perfect for me to enjoy a good meal, and truth is, this restaurant makes my this all a reality."
        self.commentView.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if self.commentView.textColor == UIColor.lightGray {
            self.commentView.text = ""
            self.commentView.textColor = UIColor(red: 63/255, green: 63/255, blue: 63/255, alpha: 1)
            
            //init(red: 63, green: 63, blue: 63, alpha: 1)
        }
    }
    
    //I NEED HEEEEEELP HERE JEFF, THIS "IF" DOESN'T WORK ---------------------------------
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if self.commentView.text == "" {
            self.commentView.text = "Example: This has got to be my favorite burger place! Every time I come here, the customer service and quality of food never disappoint. I'm a huge burger fan, so my patties, fries, and bacon all have to be perfect for me to enjoy a good meal, and truth is, this restaurant makes my this all a reality."
            self.commentView.textColor = UIColor.lightGray
        }
    }
    
    private func changeStars(num: Int)
    {
        if num == 0
        {
            self.reviewStarOne.setImage(UIImage(named: "graystar"), for: UIControlState.normal)
            self.reviewStarTwo.setImage(UIImage(named: "graystar"), for: UIControlState.normal)
            self.reviewStarThree.setImage(UIImage(named: "graystar"), for: UIControlState.normal)
            self.reviewStarFour.setImage(UIImage(named: "graystar"), for: UIControlState.normal)
            self.reviewStarFive.setImage(UIImage(named: "graystar"), for: UIControlState.normal)
            
        }
        else if num == 1
        {
            self.reviewStarOne.setImage(UIImage(named: "fullstar"), for: UIControlState.normal)
            self.reviewStarTwo.setImage(UIImage(named: "graystar"), for: UIControlState.normal)
            self.reviewStarThree.setImage(UIImage(named: "graystar"), for: UIControlState.normal)
            self.reviewStarFour.setImage(UIImage(named: "graystar"), for: UIControlState.normal)
            self.reviewStarFive.setImage(UIImage(named: "graystar"), for: UIControlState.normal)
            
        }
        else if num == 2
        {
            self.reviewStarOne.setImage(UIImage(named: "fullstar"), for: UIControlState.normal)
            self.reviewStarTwo.setImage(UIImage(named: "fullstar"), for: UIControlState.normal)
            self.reviewStarThree.setImage(UIImage(named: "graystar"), for: UIControlState.normal)
            self.reviewStarFour.setImage(UIImage(named: "graystar"), for: UIControlState.normal)
            self.reviewStarFive.setImage(UIImage(named: "graystar"), for: UIControlState.normal)
        }
        else if num == 3
        {
            self.reviewStarOne.setImage(UIImage(named: "fullstar"), for: UIControlState.normal)
            self.reviewStarTwo.setImage(UIImage(named: "fullstar"), for: UIControlState.normal)
            self.reviewStarThree.setImage(UIImage(named: "fullstar"), for: UIControlState.normal)
            self.reviewStarFour.setImage(UIImage(named: "graystar"), for: UIControlState.normal)
            self.reviewStarFive.setImage(UIImage(named: "graystar"), for: UIControlState.normal)
        }
        else if num == 4
        {
            self.reviewStarOne.setImage(UIImage(named: "fullstar"), for: UIControlState.normal)
            self.reviewStarTwo.setImage(UIImage(named: "fullstar"), for: UIControlState.normal)
            self.reviewStarThree.setImage(UIImage(named: "fullstar"), for: UIControlState.normal)
            self.reviewStarFour.setImage(UIImage(named: "fullstar"), for: UIControlState.normal)
            self.reviewStarFive.setImage(UIImage(named: "graystar"), for: UIControlState.normal)
        }
        else if num == 5
        {
            self.reviewStarOne.setImage(UIImage(named: "fullstar"), for: UIControlState.normal)
            self.reviewStarTwo.setImage(UIImage(named: "fullstar"), for: UIControlState.normal)
            self.reviewStarThree.setImage(UIImage(named: "fullstar"), for: UIControlState.normal)
            self.reviewStarFour.setImage(UIImage(named: "fullstar"), for: UIControlState.normal)
            self.reviewStarFive.setImage(UIImage(named: "fullstar"), for: UIControlState.normal)
        }
    }
    @IBAction func valueChanged(_ sender: Any)
    {
        self.changeStars(num: Int(roundf(reviewSlider.value)))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromAddReview"
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let businessViewController = segue.destination as! BusinessViewController
            let review = Review(id: businessViewController.getURL(), review: Int(self.reviewSlider.value), reviewer: appDelegate.accessICloudName(), summaryReview: self.commentView.text)
            
            businessViewController.cloudKitDatabaseHandler.appendToArrayOfReviews(review: review)
    
            
            businessViewController.cloudKitDatabaseHandler.addToDatabase(review: review)
            
        }
    }
    

}

extension AddReviewViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
