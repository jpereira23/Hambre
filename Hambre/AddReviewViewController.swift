
//
//  AddReviewViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/2/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class AddReviewViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var reviewSlider: UISlider!
    @IBOutlet weak var greetingField: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        reviewSlider.maximumValue = 5
        reviewSlider.minimumValue = 0
        reviewSlider.setValue(0.0, animated: animated)
        sliderLabel.text = String(0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.greetingField.text = "Please submit your review, " + appDelegate.accessICloudName()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func valueChanged(_ sender: Any)
    {
        sliderLabel.text = String(Int(roundf(reviewSlider.value)))
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
            let review = Review(id: businessViewController.getURL(), review: Int(self.reviewSlider.value), reviewer: appDelegate.accessICloudName())
    
            
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
