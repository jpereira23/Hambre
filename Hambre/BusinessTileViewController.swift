//
//  BusinessTileViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/29/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import CoreLocation

class BusinessTileViewController: UIViewController {

    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var distanceField: UILabel!
    @IBOutlet var infoButton: UIButton!
    
    @IBOutlet var locationImage: UIImageView!
    @IBOutlet var genreLabel: UILabel!
    var aBusinessTileOperator : BusinessTileOperator! = nil
    var yelpContainer: YelpContainer?
    private var genre = "all restuarants"
    private var cityState = "San Francisco, California"
    private var distance = 0
    public var checkIfReady = 0
    public var theCoordinate : CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.delegate = self
        print("BusinessTileViewController appeared")
        self.businessImage.isHidden = true
        self.businessNameLabel.isHidden = true
        self.leftButton.isEnabled = false
        self.rightButton.isEnabled = false
        self.infoButton.isEnabled = false
        //self.refreshButton.isHidden = true
        self.activityIndicator.startAnimating()
        //self.genreLabel.text = "Genre: " + self.genre
        yelpContainer?.delegate = self
        
        // Do any additional setup after loading the view.
        
        //tile view title
        self.title = "Zendish"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Righteous-Regular", size: 20)!]

        
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
        self.infoButton.setImage(UIImage(named: "Info.png"), for: .selected)
        self.infoButton.setImage(UIImage(named: "Info.png"), for: .highlighted)
        
        if !appDelegate.isInternetAvailable()
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "noInternetConnectionViewController")
            self.present(controller, animated: true, completion: nil)
            
            /*
            self.infoButton.isHidden = true
            self.distanceField.isHidden = true
            self.activityIndicator.isHidden = true
            self.leftButton.isHidden = true
            self.rightButton.isHidden = true
            self.distanceField.isHidden = true
            self.infoButton.isHidden = true
            self.businessNameLabel.isHidden = true
            self.businessImage.isHidden = true
            self.locationImage.isHidden = true
            self.tabBarController?.tabBar.isHidden = true
            */
        }
        //self.yelpContainer = YelpContainer()
        
        
        
    }
    public func recallYelpContainer()
    {
        self.yelpContainer = nil
        self.yelpContainer = YelpContainer()
        self.yelpContainer?.delegate = self
        self.yelpContainer?.yelpAPICallForBusinesses()
    }
    
    public func setDistance(distance: Int)
    {
        self.distance = distance
    }
    
    public func setGenre(genre: String)
    {
        self.genre = genre 
    }
    
    public func setCityState(cityState: String)
    {
        self.cityState = cityState
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refreshButton(_ sender: Any)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.isInternetAvailable()
        {
            self.yelpContainer = nil
            
            self.yelpContainer = YelpContainer()
            self.yelpContainer?.delegate = self
            
            self.infoButton.isHidden = false
            self.distanceField.isHidden = false
            self.activityIndicator.isHidden = false
            self.leftButton.isHidden = false
            self.rightButton.isHidden = false
            self.distanceField.isHidden = false
            self.infoButton.isHidden = false
            self.businessNameLabel.isHidden = false
            self.businessImage.isHidden = false
            self.locationImage.isHidden = false
            self.tabBarController?.tabBar.isHidden = false
            //self.refreshButton.isHidden = true
        }
    }
   
    
    public func className() -> String
    {
        return String(describing: self.classForCoder)
    }
    
    public func cityRequiresRefresh()
    {
        self.yelpContainer?.yelpAPICallForBusinesses()
    }
    
    @IBAction func unwindToTileView(_ sender: UIStoryboardSegue)
    {
        if sender.identifier == "fromGenre"
        {
            self.businessImage.isHidden = true
            self.businessNameLabel.isHidden = true
            self.leftButton.isEnabled = false
            self.rightButton.isEnabled = false
            self.infoButton.isEnabled = false
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.yelpContainer?.changeGenre(genre: self.genre)
            
        }
        else if sender.identifier == "genreToTile"
        {
            self.businessImage.isHidden = true
            self.businessNameLabel.isHidden = true
            self.leftButton.isEnabled = false
            self.rightButton.isEnabled = false
            self.infoButton.isEnabled = false
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            self.yelpContainer?.changeGenre(genre: self.genre)
        }
        else if sender.identifier == "settingsToTile"
        {
            self.businessImage.isHidden = true
            self.businessNameLabel.isHidden = true
            self.leftButton.isEnabled = false
            self.rightButton.isEnabled = false
            self.infoButton.isEnabled = false
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            print("And the distance is \(self.distance)")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let radiiDistances = RadiiDistances(latitude: appDelegate.getLatitude(), longitude: appDelegate.getLongitude(), distance: Double(self.distance))
            radiiDistances.printFinalResults()
            self.yelpContainer?.setCityState(cityState: self.cityState)
        }
        else if sender.identifier == "noInternetToTile"
        {
            self.recallYelpContainer()

        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "fromTileView"
        {
            let businessViewController = segue.destination as! BusinessViewController
            businessViewController.setIdentifier(id: "fromTileView")
            
            businessViewController.setUrl(aUrl: self.aBusinessTileOperator.presentCurrentBusiness().getBusinessImage())
            businessViewController.setLongitude(longitude: self.aBusinessTileOperator.presentCurrentBusiness().getLongitude())
            businessViewController.setLatitude(latitude: self.aBusinessTileOperator.presentCurrentBusiness().getLatitude())
            businessViewController.setPhoneNumber(phone: self.aBusinessTileOperator.presentCurrentBusiness().getNumber())
            businessViewController.setWebsiteUrl(url: self.aBusinessTileOperator.presentCurrentBusiness().getWebsiteUrl())
            businessViewController.setIsClosed(isClosed: self.aBusinessTileOperator.presentCurrentBusiness().getIsClosed())
            businessViewController.setAddress(address: self.aBusinessTileOperator.presentCurrentBusiness().getAddress())
            businessViewController.setTitle(title: self.aBusinessTileOperator.presentCurrentBusiness().getBusinessName())
            
        }
        else if segue.identifier == "tileToSetting"
        {
            let settingsViewController = segue.destination as! SettingsViewController
            settingsViewController.setSliderValue(value: self.distance)
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
        self.distanceField.text = String(self.aBusinessTileOperator.presentCurrentBusiness().getDistance()) + " mile(s)"
        
        self.businessNameLabel.text = aBusiness.getBusinessName()
        self.businessImage.setImageWith(aBusiness.getBusinessImage())
        self.businessImage.contentMode = UIViewContentMode.scaleToFill
    }

}

extension BusinessTileViewController : YelpContainerDelegate
{
    func yelpLocationCallback(_ yelpContainer: YelpContainer) {
        self.checkIfReady = self.checkIfReady + 1
        
    }

    func yelpAPICallback(_ yelpContainer: YelpContainer) {
        
      
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.businessImage.isHidden = false
            self.businessNameLabel.isHidden = false
            self.leftButton.isEnabled = true
            self.rightButton.isEnabled = true
            self.infoButton.isEnabled = true
            self.aBusinessTileOperator = nil
            self.aBusinessTileOperator = BusinessTileOperator(anArrayOfBusinesses: yelpContainer.getBusinesses(), city: yelpContainer.getCity(), state: yelpContainer.getState())
            self.refreshTileAttributes()
 
        
        
    }
}

extension BusinessTileViewController : AppDelegateDelegate
{
    func locationServicesUpdated(appDelegate: AppDelegate) {
         
        self.yelpContainer = nil
        
        self.yelpContainer = YelpContainer()
        self.yelpContainer?.delegate = self
        self.yelpContainer?.yelpAPICallForBusinesses()
    }
}
