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
    @IBOutlet weak var distanceField: UILabel!
    @IBOutlet var infoButton: UIButton!
    
    @IBOutlet var genreLabel: UILabel!
    var aBusinessTileOperator : BusinessTileOperator! = nil
    let yelpContainer = YelpContainer()
    private var genre = "all restuarants"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("BusinessTileViewController appeared")
        self.businessImage.isHidden = true
        self.businessNameLabel.isHidden = true
        self.leftButton.isEnabled = false
        self.rightButton.isEnabled = false
        self.infoButton.isEnabled = false
        self.activityIndicator.startAnimating()
        //self.genreLabel.text = "Genre: " + self.genre
        yelpContainer.delegate = self
        
        // Do any additional setup after loading the view.
        
        //right button states
        self.rightButton.setImage(UIImage(named: "Heart.png"), for: .normal)
        self.rightButton.setImage(UIImage(named: "Heart.png"), for: .selected)
        self.rightButton.setImage(UIImage(named: "Heart.png"), for: .highlighted)
        //left button states
        self.leftButton.setImage(UIImage(named: "Not.png"), for: .normal)
        self.leftButton.setImage(UIImage(named: "Not.png"), for: .selected)
        self.leftButton.setImage(UIImage(named: "Not.png"), for: .highlighted)
        //info button states
        self.infoButton.setImage(UIImage(named: "Info.png"), for: .normal)
        self.infoButton.setImage(UIImage(named: "Infox.png"), for: .selected)
        self.infoButton.setImage(UIImage(named: "Infox.png"), for: .highlighted)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func changeGenre(genre: String)
    {
        self.genre = genre
        
    }
    
    public func className() -> String
    {
        return String(describing: self.classForCoder)
    }
    
    public func cityRequiresRefresh()
    {
        self.yelpContainer.yelpAPICallForBusinesses()
    }
    
    @IBAction func unwindToTileView(_ sender: UIStoryboardSegue)
    {
        if sender.identifier == "fromGenre"
        {
            self.genreLabel.text = "Genre: " + self.genre
            self.businessImage.isHidden = true
            self.businessNameLabel.isHidden = true
            self.leftButton.isEnabled = false
            self.rightButton.isEnabled = false
            self.infoButton.isEnabled = false
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.yelpContainer.changeGenre(genre: self.genre)
            
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "fromTileView"
        {
            /*
            let navigationViewController = segue.destination as! UINavigationController
            
            let navBar = navigationViewController.navigationBar
            
            /*
             let backItem = UIBarButtonItem()
             backItem.title = "Back"
             navigationViewController.navigationItem.backBarButtonItem = backItem
 
            
            navBar.topItem?.title = self.aBusinessTileOperator.presentCurrentBusiness().getBusinessName()
            navBar.tintColor = UIColor.white
            navBar.titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20.0), NSForegroundColorAttributeName: UIColor.white]
            
            //navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            navBar.barTintColor = UIColor(red: 252/255, green: 193/255, blue: 61/255, alpha: 1)
    */
 */
            
            let businessViewController = segue.destination as! BusinessViewController
            businessViewController.setIdentifier(id: "fromTileView")
            
            businessViewController.setUrl(aUrl: self.aBusinessTileOperator.presentCurrentBusiness().getBusinessImage())
            businessViewController.setLongitude(longitude: self.aBusinessTileOperator.presentCurrentBusiness().getLongitude())
            businessViewController.setLatitude(latitude: self.aBusinessTileOperator.presentCurrentBusiness().getLatitude())
            businessViewController.setPhoneNumber(phone: self.aBusinessTileOperator.presentCurrentBusiness().getNumber())
            businessViewController.setWebsiteUrl(url: self.aBusinessTileOperator.presentCurrentBusiness().getWebsiteUrl())
            businessViewController.setIsClosed(isClosed: self.aBusinessTileOperator.presentCurrentBusiness().getIsClosed())
            businessViewController.setAddress(address: self.aBusinessTileOperator.presentCurrentBusiness().getAddress())
            
        }
    }
    
    
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
        self.businessImage.contentMode = UIViewContentMode.scaleAspectFit
        self.distanceField.text = String(aBusiness.getDistance()) + " mile(s)"
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
        self.infoButton.isEnabled = true
        self.aBusinessTileOperator = BusinessTileOperator(anArrayOfBusinesses: yelpContainer.getBusinesses(), city: yelpContainer.getCity(), state: yelpContainer.getState())
        self.refreshTileAttributes()
        
    }
}
