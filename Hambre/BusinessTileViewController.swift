//
//  BusinessTileViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/29/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces

class BusinessTileViewController: UIViewController{

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet var infoButton: UIButton!
    
    @IBOutlet var locationImage: UIImageView!
    var aBusinessTileOperator : BusinessTileOperator! = nil
    var yelpContainer: YelpContainer?
    private var arrayOfBusinesses = [PersonalBusiness]()
    private var genre = "all restuarants"
    private var cityState = "San Francisco, California"
    private var arrayOfPlaces = [String]()
    private var distance = 0
    public var radiiDistances : RadiiDistances! = nil
    private var indexOfSelectedGenre = 0
    public var checkIfReady = 0
    public var theCoordinate : CLLocationCoordinate2D!
    private var initialCall = false
    public var cloudKitDatabaseHandler = CloudKitDatabaseHandler()
    public var arrayOfReviews = [Review]()
    
    let maskView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.delegate = self
        
        self.cloudKitDatabaseHandler.delegate = self
        
        self.tabBarController?.delegate = self
        
        print("BusinessTileViewController appeared")
        //self.businessImage.isHidden = true
        //self.businessImage1.isHidden = true
        //self.businessNameLabel.isHidden = true
        self.leftButton.isEnabled = false
        self.rightButton.isEnabled = false
        self.infoButton.isEnabled = false
        //self.refreshButton.isHidden = true
        self.activityIndicator.startAnimating()
        //self.genreLabel.text = "Genre: " + self.genre
        yelpContainer?.delegate = self
        
        //tile image masked
        maskView.image = UIImage(named: "Tile")
        //businessImage.mask = maskView
        //businessImage1.mask = maskView
        
        //tile view title
        self.title = "Discover"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightSemibold), NSForegroundColorAttributeName: UIColor.white]
        
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
        
        if !appDelegate.isInternetAvailable()
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "noInternetConnectionViewController")
            self.present(controller, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //maskView.frame = businessImage.bounds
        //maskView.frame = businessImage1.bounds
    }
    
    public func isInitailCall() -> Bool
    {
        return self.initialCall
    }
    
    public func setIndexOfSelectedGenre(index: Int)
    {
        self.indexOfSelectedGenre = index
    }
    
    public func getIndexOfSelectedGenre() -> Int
    {
        return self.indexOfSelectedGenre
    }
    
    public func getGenre() -> String
    {
        return self.genre
    }
    public func initialCallWasCalled()
    {
        self.initialCall = true
    }
    
    public func setTheCoordinate(coordinate: CLLocationCoordinate2D)
    {
        self.theCoordinate = coordinate
    }
    
    public func addToArrayOfPlaces(place: String)
    {
        self.arrayOfPlaces.append(place)
    }
    public func recallYelpContainer()
    {
        self.yelpContainer = nil
        self.yelpContainer = YelpContainer(cityAndState: self.cityState)
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
    
    public func getCityState() -> String
    {
        return self.cityState
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func className() -> String
    {
        return String(describing: self.classForCoder)
    }
    
    public func cityRequiresRefresh()
    {
        self.yelpContainer?.yelpAPICallForBusinesses()
    }
    
    @IBAction func promptGoogleAPI(_ sender: Any)
    {
        let autocompleteController = GMSAutocompleteViewController()
        
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func unwindToTileView(_ sender: UIStoryboardSegue)
    {
        if sender.identifier == "fromGenre"
        {
            //self.businessImage.isHidden = true
            //self.businessImage1.isHidden = true
            //self.businessNameLabel.isHidden = true
            self.leftButton.isEnabled = false
            self.rightButton.isEnabled = false
            self.infoButton.isEnabled = false
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.yelpContainer?.changeGenre(genre: self.genre)
            
        }
        else if sender.identifier == "genreToTile"
        {
            //self.businessImage.isHidden = true
            //self.businessImage1.isHidden = true
            //self.businessNameLabel.isHidden = true
            self.leftButton.isEnabled = false
            self.rightButton.isEnabled = false
            self.infoButton.isEnabled = false
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            
            self.yelpContainer?.changeGenre(genre: self.genre)
        }
        else if sender.identifier == "settingsToTile"
        {
            //self.businessImage.isHidden = true
            //self.businessImage1.isHidden = true
            //self.businessNameLabel.isHidden = true
            self.leftButton.isEnabled = false
            self.rightButton.isEnabled = false
            self.infoButton.isEnabled = false
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.aBusinessTileOperator.removeAllBusinesses()
            if self.distance == 0
            {
                self.yelpContainer = nil
                
                self.yelpContainer = YelpContainer(cityAndState: self.cityState)
                self.yelpContainer?.delegate = self
                self.yelpContainer?.changeGenre(genre: self.genre)
                self.yelpContainer?.yelpAPICallForBusinesses()
            }
            print("And the distance is \(self.distance)")
            // Change this below to be relative to the latitude and longitude of set city too not necessarily the one you are on 

            self.radiiDistances = RadiiDistances(latitude: self.theCoordinate.latitude, longitude: self.theCoordinate.longitude, distance: Double(self.distance))
            self.radiiDistances.delegate = self
            
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
        else if segue.identifier == "tileToSettings"
        {
            let settingsViewController = segue.destination as! SettingsPopOverViewController
            settingsViewController.setSliderValue(value: self.distance)
            settingsViewController.setSelectedCell(index: self.indexOfSelectedGenre)
        }
    }
    
    public func filterArrayOfReviews(url: URL) -> Int
    {
        let stringUrl = url.absoluteString
        var tmpArray = [Review]()
        
        for review in self.arrayOfReviews
        {
            if review.getId() == stringUrl
            {
                tmpArray.append(review)
            }
        }
        
        return tmpArray.count
    }
    
    public func isPlaceAlreadyInArray(place: String) -> Bool
    {
        if self.arrayOfPlaces.contains(place)
        {
            return true
        }
        
        return false
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
        //self.distanceField.text = String(self.aBusinessTileOperator.presentCurrentBusiness().getDistance()) + " mile(s)"
        if self.arrayOfReviews.count > 0
        {
            let num = self.filterArrayOfReviews(url: aBusiness.getBusinessImage())
            //self.reviewCountField.text = String(num) + ((num > 1 || num == 0) ? " reviews" : " review")
        }
        else
        {
            //self.reviewCountField.text = "No reviews"
        }
        //self.businessNameLabel.text = aBusiness.getBusinessName()
        //self.businessImage.setImageWith(aBusiness.getBusinessImage())
        //self.businessImage1.setImageWith(aBusiness.getBusinessImage())
        //self.businessImage.contentMode = UIViewContentMode.scaleToFill
        //self.businessImage1.contentMode = UIViewContentMode.scaleToFill
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
            //self.businessImage.isHidden = false
            //self.businessImage1.isHidden = false
            //self.businessNameLabel.isHidden = false
            self.leftButton.isEnabled = true
            self.rightButton.isEnabled = true
            self.infoButton.isEnabled = true
        if self.aBusinessTileOperator == nil
        {
            self.aBusinessTileOperator = BusinessTileOperator(city: yelpContainer.getCity(), state: yelpContainer.getState(), coordinate: self.theCoordinate)
            self.aBusinessTileOperator.addBusinesses(arrayOfBusinesses: yelpContainer.getBusinesses())
            self.refreshTileAttributes()
        }
        else
        {
            self.aBusinessTileOperator.setTheCoordinate(coordinate: self.theCoordinate)
            self.aBusinessTileOperator.addBusinesses(arrayOfBusinesses: yelpContainer.getBusinesses())
            self.refreshTileAttributes()
        }
    }
}

extension BusinessTileViewController : AppDelegateDelegate
{
    func locationServicesUpdated(appDelegate: AppDelegate) {
        
        if !self.isInitailCall()
        {
            self.setCityState(cityState: appDelegate.getCityAndState())
            self.setTheCoordinate(coordinate: appDelegate.getCoordinate())
            let radiusCoreData = RadiusCoreData()
            if !radiusCoreData.checkIfCoreDataIsEmpty()
            {
                let distance = radiusCoreData.loadRadius()
                self.radiiDistances = RadiiDistances(latitude: self.theCoordinate.latitude, longitude: self.theCoordinate.longitude, distance: Double(distance))
                self.radiiDistances.delegate = self
                
            }
            self.initialCallWasCalled()
            self.yelpContainer = nil
            self.setCityState(cityState: appDelegate.getCityAndState())
            self.setTheCoordinate(coordinate: appDelegate.getCoordinate())
            self.yelpContainer = YelpContainer(cityAndState: appDelegate.getCityAndState())
            self.yelpContainer?.delegate = self
            self.yelpContainer?.yelpAPICallForBusinesses()
        }
    }
}

extension BusinessTileViewController : RadiiDistancesDelegate
{
    func placeFound(place: String, radiiDistances: RadiiDistances) {
        
        if !self.isPlaceAlreadyInArray(place: place)
        {
            self.addToArrayOfPlaces(place: place)
            self.yelpContainer = nil
            
            self.yelpContainer = YelpContainer(cityAndState: place)
            self.yelpContainer?.changeGenre(genre: self.getGenre())
            self.yelpContainer?.delegate = self
            self.yelpContainer?.yelpAPICallForBusinesses()
        }
        
    }
}

extension BusinessTileViewController : GMSAutocompleteViewControllerDelegate
{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.setTheCoordinate(coordinate: place.coordinate)
        self.setCityState(cityState: place.formattedAddress!)
        self.yelpContainer = nil
        self.yelpContainer = YelpContainer(cityAndState: place.formattedAddress!)
        self.yelpContainer?.delegate = self
        self.yelpContainer?.yelpAPICallForBusinesses()
        if self.aBusinessTileOperator != nil
        {
            self.aBusinessTileOperator.removeAllBusinesses()
        }
        self.activityIndicator.isHidden = false
        //self.businessImage.isHidden = true
        //self.businessImage1.isHidden = true
        //self.businessNameLabel.isHidden = true
        self.leftButton.isEnabled = false
        self.rightButton.isEnabled = false
        self.infoButton.isEnabled = false
        self.activityIndicator.startAnimating()
        dismiss(animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: \(error)")
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        return true
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension BusinessTileViewController : UITabBarControllerDelegate
{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if self.presentedViewController != nil
        {
            self.presentedViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

extension BusinessTileViewController : CloudKitDatabaseHandlerDelegate
{
    func modelUpdated() {
        self.arrayOfReviews = cloudKitDatabaseHandler.accessArrayOfReviews()
    }
    
    func errorUpdating(_ error: NSError) {
        print(error)
    }
}
