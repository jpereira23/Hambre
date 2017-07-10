
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
    @IBOutlet var reviewStarOne: UIImageView!
    @IBOutlet var reviewStarTwo: UIImageView!
    @IBOutlet var reviewStarThree: UIImageView!
    @IBOutlet var reviewStarFour: UIImageView!
    @IBOutlet var reviewStarFive: UIImageView!
    private var review : Int = 0
    
    
    override func viewWillAppear(_ animated: Bool) {

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.greetingField.text = "By: " + appDelegate.accessICloudName()
        
        // Do any additional setup after loading the view.
        
        self.title = "Review"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightBold), NSForegroundColorAttributeName: UIColor.white]
        let firstStarRecognizer = UITapGestureRecognizer(target: self, action: #selector(firstStarTapped(tapGestureRecognizer:)))
        self.reviewStarOne.isUserInteractionEnabled = true
        self.reviewStarOne.addGestureRecognizer(firstStarRecognizer)
        let secondStarRecognizer = UITapGestureRecognizer(target: self, action: #selector(secondStarTapped(tapGestureRecognizer:)))
        self.reviewStarTwo.isUserInteractionEnabled = true
        self.reviewStarTwo.addGestureRecognizer(secondStarRecognizer)
        let thirdStarRecognizer = UITapGestureRecognizer(target: self, action: #selector(thirdStarTapped(tapGestureRecognizer:)))
        self.reviewStarThree.isUserInteractionEnabled = true
        self.reviewStarThree.addGestureRecognizer(thirdStarRecognizer)
        let fourthStarRecognizer = UITapGestureRecognizer(target: self, action: #selector(fourthStarTapped(tapGestureRecognizer:)))
        self.reviewStarFour.isUserInteractionEnabled = true
        self.reviewStarFour.addGestureRecognizer(fourthStarRecognizer)
        let fifthStarRecognizer = UITapGestureRecognizer(target: self, action: #selector(fifthStarTapped(tapGestureRecognizer:)))
        self.reviewStarFive.isUserInteractionEnabled = true
        self.reviewStarFive.addGestureRecognizer(fifthStarRecognizer)
        
        
        
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
    
    func firstStarTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.reviewStarOne.image = UIImage(named: "fullstar")
        self.reviewStarTwo.image = UIImage(named: "graystar")
        self.reviewStarThree.image = UIImage(named: "graystar")
        self.reviewStarFour.image = UIImage(named: "graystar")
        self.reviewStarFive.image = UIImage(named: "graystar")
        self.review = 1
    }
 
    func secondStarTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.reviewStarOne.image = UIImage(named: "fullstar")
        self.reviewStarTwo.image = UIImage(named: "fullstar")
        self.reviewStarThree.image = UIImage(named: "graystar")
        self.reviewStarFour.image = UIImage(named: "graystar")
        self.reviewStarFive.image = UIImage(named: "graystar")
        self.review = 2
    }
    
    func thirdStarTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.reviewStarOne.image = UIImage(named: "fullstar")
        self.reviewStarTwo.image = UIImage(named: "fullstar")
        self.reviewStarThree.image = UIImage(named: "fullstar")
        self.reviewStarFour.image = UIImage(named: "graystar")
        self.reviewStarFive.image = UIImage(named: "graystar")
        self.review = 3
    }
    
    func fourthStarTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.reviewStarOne.image = UIImage(named: "fullstar")
        self.reviewStarTwo.image = UIImage(named: "fullstar")
        self.reviewStarThree.image = UIImage(named: "fullstar")
        self.reviewStarFour.image = UIImage(named: "fullstar")
        self.reviewStarFive.image = UIImage(named: "graystar")
        self.review = 4
    }
    
    func fifthStarTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.reviewStarOne.image = UIImage(named: "fullstar")
        self.reviewStarTwo.image = UIImage(named: "fullstar")
        self.reviewStarThree.image = UIImage(named: "fullstar")
        self.reviewStarFour.image = UIImage(named: "fullstar")
        self.reviewStarFive.image = UIImage(named: "fullstar")
        self.review = 5
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
            let review = Review(id: businessViewController.getURL(), review: self.review, reviewer: appDelegate.accessICloudName(), summaryReview: self.commentView.text)
            
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
