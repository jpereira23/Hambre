//
//  BusinessTileViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/29/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class BusinessTileViewController: UIViewController {

    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var aBusinessTileOperator : BusinessTileOperator! = nil
    let yelpContainer = YelpContainer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.businessImage.isHidden = true
        self.businessNameLabel.isHidden = true
        self.leftButton.isEnabled = false
        self.rightButton.isEnabled = false
        self.activityIndicator.startAnimating()
        
        yelpContainer.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func swipeLeft(_ sender: Any) {
        self.aBusinessTileOperator.swipeLeft()
        self.refreshTileAttributes()
    }
    
    @IBAction func swipeRight(_ sender: Any) {
        self.aBusinessTileOperator.swipeRight()
        self.refreshTileAttributes()
    }
    
    public func refreshTileAttributes()
    {
        let aBusiness = self.aBusinessTileOperator.presentCurrentBusiness()
        
        self.businessNameLabel.text = aBusiness.getBusinessName()
        self.businessImage.setImageWith(aBusiness.getBusinessImage())
        self.businessImage.contentMode = UIViewContentMode.scaleAspectFill
    }

}

extension BusinessTileViewController : YelpContainerDelegate
{
    func yelpAPICallback(_ yelpContainer: YelpContainer) {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.businessImage.isHidden = false
        self.businessNameLabel.isHidden = false
        self.leftButton.isEnabled = true
        self.rightButton.isEnabled = true
        self.aBusinessTileOperator = BusinessTileOperator(anArrayOfBusinesses: yelpContainer.getBusinesses(), city: yelpContainer.getCity(), state: yelpContainer.getState())
        self.refreshTileAttributes()
        
    }
}
