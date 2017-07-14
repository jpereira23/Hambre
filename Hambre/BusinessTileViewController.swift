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


class BusinessTileViewController: UIViewController, DraggableViewDelegate, YelpContainerDelegate, RadiiDistancesDelegate{
@IBOutlet weak var locationIcon: UIBarButtonItem!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessImage1: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet var infoButton: UIButton!
    
    @IBOutlet var locationImage: UIImageView!
    var aBusinessTileOperator : BusinessTileOperator! = nil
    var yelpContainer: YelpContainer?
    public var arrayOfBusinesses = [PersonalBusiness]()
    public var loadedCards = [DraggableView?]()
    public var personalBusinessCoreData : PersonalBusinessCoreData!
    private var genre = "restaurants"
    private var cityState = "San Francisco, California"
    public var arrayOfPlaces = [String]()
    private var distance = 0
    public var radiiDistances : RadiiDistances! = nil
    private var indexOfSelectedGenre = 0
    public var checkIfReady = 0
    private var globalIndexForCurrentCompany = 0
    public var theCoordinate : CLLocationCoordinate2D!
    private var initialCall = false
    public var cloudKitDatabaseHandler = CloudKitDatabaseHandler()
    public var arrayOfReviews = [Review]()
    public var backgroundView : DraggableView?
    public var forgroundView : DraggableView?
    public var anotherView : DraggableView?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    public var radiusIndex = 0
    var MAX_BUFFER_SIZE: Int = 2
    
    let maskView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.delegate = self
        appDelegate.checkForLocationServices()
        self.cloudKitDatabaseHandler.delegate = self
        
        if !appDelegate.isLocationEnabled()
        {
            let alert = UIAlertController(title: "Location Disabled", message: "Your Location is Disabled go to Settings > Zendish and enable them. Features of the app are currently limited.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                // perhaps use action.title here
            })
            
            self.present(alert, animated: true)
        }
        
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let viewController = storyboard.instantiateViewController(withIdentifier: "slideShowView")
        
        //self.present(viewController, animated:true, completion:nil)
        self.tabBarController?.delegate = self

        self.leftButton.isEnabled = false
        self.rightButton.isEnabled = false
        self.infoButton.isEnabled = false
        self.activityIndicator.startAnimating()
        yelpContainer?.delegate = self
        
        
        //custom back button
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "BackChevron")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "BackChevron")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        
        //tile image masked
        maskView.image = UIImage(named: "Tile")
        //businessImage.mask = maskView
        //businessImage1.mask = maskView
        
        //tile view title
        self.title = "Discover"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightBold), NSForegroundColorAttributeName: UIColor.white]
        
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
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    
    func cardSwipedLeft(_ card: UIView) {
        
        if self.arrayOfBusinesses.count != 1 || self.arrayOfBusinesses.count != 0
        {
            loadedCards.remove(at: 0)
            backgroundView?.removeFromSuperview()
            backgroundView = nil
            loadedCards.remove(at: 0)
            forgroundView?.removeFromSuperview()
            forgroundView = nil
            loadedCards.remove(at: 0)
            anotherView?.removeFromSuperview()
            anotherView = nil
        }
        else
        {
            let aView = self.createDraggableViewWithData(at: 0)
            loadedCards.append(aView)
            loadedCards[0]?.xibSetUp()
            backgroundView = loadedCards[0]?.getView() as? DraggableView
            backgroundView?.frame.origin.x = 25
            backgroundView?.frame.origin.y = 86
            self.view.addSubview(backgroundView!)
        }
        
        if self.arrayOfBusinesses.count > 0
        {
            if self.arrayOfBusinesses.count == 1
            {
                let aView = self.createDraggableViewWithData(at: 0)
                loadedCards.append(aView)
                loadedCards[0]?.xibSetUp()
                backgroundView = loadedCards[0]?.getView() as? DraggableView
                backgroundView?.frame.origin.x = 25
                backgroundView?.frame.origin.y = 86
                self.view.addSubview(backgroundView!)
            }
            else
            {
                if self.globalIndexForCurrentCompany + 1 >= self.arrayOfBusinesses.count
                {
                    self.globalIndexForCurrentCompany = 0
                }
                let aView = self.createDraggableViewWithData(at: self.globalIndexForCurrentCompany + 1)
                let aView1 = self.createDraggableViewWithData(at: self.globalIndexForCurrentCompany)
                let aView2 = self.createDraggableViewWithData(at: self.globalIndexForCurrentCompany + 1)
                loadedCards.append(aView)
                loadedCards.append(aView1)
                loadedCards.append(aView2)
                loadedCards[0]?.xibSetUp()
                loadedCards[1]?.xibSetUp()
                loadedCards[2]?.xibSetUp()
                backgroundView = loadedCards[0]?.getView() as? DraggableView
                forgroundView = loadedCards[1]?.getView() as? DraggableView
                anotherView = loadedCards[2]?.getView() as? DraggableView
                backgroundView?.frame.origin.x = 25
                forgroundView?.frame.origin.x = 25
                anotherView?.frame.origin.x = 25
                backgroundView?.frame.origin.y = 86
                forgroundView?.frame.origin.y = 86
                anotherView?.frame.origin.y = 86
                self.view.addSubview(backgroundView!)
                self.view.insertSubview(forgroundView!, belowSubview:anotherView!)
                self.globalIndexForCurrentCompany += 1
            }
        }
    }
    
    func cardSwipedRight(_ card: UIView) {
        
        
        
        if self.arrayOfBusinesses.count == 1
        {
            self.personalBusinessCoreData.saveBusiness(personalBusiness: (loadedCards[0]?.getBusiness())!)
            self.arrayOfBusinesses.remove(at: 0)
        }
        else
        {
            self.personalBusinessCoreData.saveBusiness(personalBusiness: (loadedCards[1]?.getBusiness())!)
            self.arrayOfBusinesses.remove(at: self.globalIndexForCurrentCompany-1)
        }
        
        if self.arrayOfBusinesses.count != 0
        {
            loadedCards.remove(at: 0)
            backgroundView?.removeFromSuperview()
            backgroundView = nil
            loadedCards.remove(at: 0)
            forgroundView?.removeFromSuperview()
            forgroundView = nil
            loadedCards.remove(at: 0)
            anotherView?.removeFromSuperview()
            anotherView = nil
        }
        if self.arrayOfBusinesses.count > 0
        {
            if self.arrayOfBusinesses.count == 1
            {
                let aView = self.createDraggableViewWithData(at: 0)
                loadedCards.append(aView)
                loadedCards[0]?.xibSetUp()
                backgroundView = loadedCards[0]?.getView() as? DraggableView
                backgroundView?.frame.origin.x = 25
                backgroundView?.frame.origin.y = 86
                self.view.addSubview(backgroundView!)
            }
            else
            {
                if self.globalIndexForCurrentCompany + 1 >= self.arrayOfBusinesses.count
                {
                    self.globalIndexForCurrentCompany = 0
                }
                let aView = self.createDraggableViewWithData(at: self.globalIndexForCurrentCompany + 1)
                let aView1 = self.createDraggableViewWithData(at: self.globalIndexForCurrentCompany)
                let aView2 = self.createDraggableViewWithData(at: self.globalIndexForCurrentCompany + 1)
                loadedCards.append(aView)
                loadedCards.append(aView1)
                loadedCards.append(aView2)
                loadedCards[0]?.xibSetUp()
                loadedCards[1]?.xibSetUp()
                loadedCards[2]?.xibSetUp()
                backgroundView = loadedCards[0]?.getView() as? DraggableView
                forgroundView = loadedCards[1]?.getView() as? DraggableView
                anotherView = loadedCards[2]?.getView() as? DraggableView
                backgroundView?.frame.origin.x = 25
                forgroundView?.frame.origin.x = 25
                anotherView?.frame.origin.x = 25
                backgroundView?.frame.origin.y = 86
                forgroundView?.frame.origin.y = 86
                anotherView?.frame.origin.y = 86
                self.view.addSubview(backgroundView!)
                self.view.insertSubview(forgroundView!, belowSubview:anotherView!)
                self.globalIndexForCurrentCompany += 1
            }
        }
    }
    
    private func createDraggableViewWithData(at index: Int) -> DraggableView {
        let draggableView = DraggableView(frame: CGRect(x: 25, y: 86, width: 325, height: 395), floatForStar: self.cloudKitDatabaseHandler.getAverageReviews(url: self.arrayOfBusinesses[index].getBusinessImage().absoluteString))
        
        draggableView.setBusinessName(name: self.arrayOfBusinesses[index].getBusinessName())
        draggableView.setImageUrl(url: self.arrayOfBusinesses[index].getBusinessImage())
        draggableView.setBusiness(business: self.arrayOfBusinesses[index])
        draggableView.setMiles(miles: ((appDelegate.isLocationEnabled()) ? String(self.arrayOfBusinesses[index].getDistance()) + " mi" : "Miles not available"))
    

        if self.arrayOfReviews.count > 0
        {
            let num = self.filterArrayOfReviews(url: self.arrayOfBusinesses[index].getBusinessImage())
            draggableView.setReviews(reviews: String(num) + ((num > 1 || num == 0) ? " reviews" : " review"))
        }
        else
        {
            draggableView.setReviews(reviews: "No reviews")
        }
        draggableView.delegate = self
        
        return draggableView
    }
    
    public func loadCards()
    {
        if self.arrayOfBusinesses.count != 0
        {
            if self.arrayOfBusinesses.count == 1
            {
                let aView = self.createDraggableViewWithData(at: 0)
                loadedCards.append(aView)
                loadedCards[0]?.xibSetUp()
                backgroundView = loadedCards[0]?.getView() as? DraggableView
                backgroundView?.frame.origin.x = 25
                backgroundView?.frame.origin.y = 86
                self.view.addSubview(backgroundView!)
            }
            else
            {
                if self.globalIndexForCurrentCompany + 1 >= self.arrayOfBusinesses.count
                {
                    self.globalIndexForCurrentCompany = 0
                }
               
                let aView = self.createDraggableViewWithData(at: self.globalIndexForCurrentCompany + 1)
                let aView1 = self.createDraggableViewWithData(at: self.globalIndexForCurrentCompany)
                let aView2 = self.createDraggableViewWithData(at: self.globalIndexForCurrentCompany + 1)
                loadedCards.append(aView)
                loadedCards.append(aView1)
                loadedCards.append(aView2)
                loadedCards[0]?.xibSetUp()
                loadedCards[1]?.xibSetUp()
                loadedCards[2]?.xibSetUp()
                backgroundView = loadedCards[0]?.getView() as? DraggableView
                forgroundView = loadedCards[1]?.getView() as? DraggableView
                anotherView = loadedCards[2]?.getView() as? DraggableView
                backgroundView?.frame.origin.x = 25
                forgroundView?.frame.origin.x = 25
                anotherView?.frame.origin.x = 25
                backgroundView?.frame.origin.y = 86
                forgroundView?.frame.origin.y = 86
                anotherView?.frame.origin.y = 86
                self.view.addSubview(backgroundView!)
                self.view.insertSubview(forgroundView!, belowSubview:anotherView!)
                self.globalIndexForCurrentCompany += 1
            }
        }
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
        var placeholderAttributes: [AnyHashable: Any] = [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.systemFont(ofSize: CGFloat(UIFont.systemFontSize))]
        // Color of the default search text.
        // NOTE: In a production scenario, "Search" would be a localized string
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func unwindToTileView(_ sender: UIStoryboardSegue)
    {
        if sender.identifier == "settingsToTile"
        {
            if !loadedCards.isEmpty
            {
                backgroundView?.isHidden = true
                forgroundView?.isHidden = true
                anotherView?.isHidden = true
                loadedCards.remove(at: 0)
                backgroundView?.removeFromSuperview()
                backgroundView = nil
                loadedCards.remove(at: 0)
                forgroundView?.removeFromSuperview()
                forgroundView = nil
                loadedCards.remove(at: 0)
                anotherView?.removeFromSuperview()
                anotherView = nil
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            }
            for view in self.view.subviews
            {
                if NSStringFromClass(view.classForCoder) == "Hambre.DraggableView"
                {
                    view.isHidden = true
                }
            }
            self.arrayOfBusinesses.removeAll()
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
            self.arrayOfPlaces.removeAll()
            self.radiiDistances = RadiiDistances(latitude: self.theCoordinate.latitude, longitude: self.theCoordinate.longitude, distance: Double(self.distance))
            self.radiiDistances.delegate = self
            self.radiiDistances.calculateForDistance(distance: Double(self.distance))
            
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
            if loadedCards.count > 0
            {
                businessViewController.setUrl(aUrl: (loadedCards[1]!.getBusiness().getBusinessImage()))
                businessViewController.setLongitude(longitude: (loadedCards[1]!.getBusiness().getLongitude()))
                businessViewController.setLatitude(latitude: (loadedCards[1]!.getBusiness().getLatitude()))
                businessViewController.setPhoneNumber(phone: (loadedCards[1]!.getBusiness().getNumber()))
                businessViewController.setWebsiteUrl(url: (loadedCards[1]!.getBusiness().getWebsiteUrl()))
                businessViewController.setIsClosed(isClosed: (loadedCards[1]!.getBusiness().getIsClosed()))
                businessViewController.setAddress(address: (loadedCards[1]!.getBusiness().getFullAddress()))
                businessViewController.setTitle(title: (loadedCards[1]!.getBusiness().getBusinessName()))
            }
            else
            {
                businessViewController.setUrl(aUrl: (loadedCards[1]!.getBusiness().getBusinessImage()))
                businessViewController.setLongitude(longitude: (loadedCards[1]!.getBusiness().getLongitude()))
                businessViewController.setLatitude(latitude: (loadedCards[1]!.getBusiness().getLatitude()))
                businessViewController.setPhoneNumber(phone: (loadedCards[1]!.getBusiness().getNumber()))
                businessViewController.setWebsiteUrl(url: (loadedCards[1]!.getBusiness().getWebsiteUrl()))
                businessViewController.setIsClosed(isClosed: (loadedCards[1]!.getBusiness().getIsClosed()))
                businessViewController.setAddress(address: (loadedCards[1]!.getBusiness().getFullAddress()))
                businessViewController.setTitle(title: (loadedCards[1]!.getBusiness().getBusinessName()))
            }
            
        }
        else if segue.identifier == "tileToSettings"
        {
            let settingsViewController = segue.destination as! SettingsPopOverViewController
            let radiusCoreData = RadiusCoreData()
            
            settingsViewController.setSliderValue(value: radiusCoreData.loadRadius())
            settingsViewController.setCityState(cityState: self.cityState)
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
        // Still needs to be worked out after what i changed for tileView
        loadedCards.first??.xibSetUp()
        let dragView: DraggableView? = loadedCards.first as! DraggableView
        dragView?.overlayView?.mode = .GGOverlayViewModeLeft
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            dragView?.overlayView?.alpha = 1
            dragView?.getView().transform = CGAffineTransform(scaleX: 11, y: 11)
        })
        dragView?.leftClickAction()
        
        
    }
    
    @IBAction func swipeRight(_ sender: Any) {
        // still needs to be worked out after what i did for tileview
        loadedCards.first??.xibSetUp()
        let dragView: DraggableView? = loadedCards.first as! DraggableView
        dragView?.overlayView?.mode = .GGOverlayViewModeRight
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            dragView?.overlayView?.alpha = 1
            
        })
        dragView?.rightClickAction()
    }
    
    private func checkAndUpdateGlobalIndex()
    {
        if (self.globalIndexForCurrentCompany + 1) >= self.arrayOfBusinesses.count
        {
            self.globalIndexForCurrentCompany = 0
        }
        else
        {
            self.globalIndexForCurrentCompany = self.globalIndexForCurrentCompany + 1
        }
    }
    
    func yelpLocationCallback(_ yelpContainer: YelpContainer) {
        self.checkIfReady = self.checkIfReady + 1
        
    }
    
    func yelpAPICallback(_ yelpContainer: YelpContainer, worked: Bool) {
        if worked == true
        {
            if !loadedCards.isEmpty
            {
                backgroundView?.isHidden = true
                forgroundView?.isHidden = true
                anotherView?.isHidden = true
                loadedCards.remove(at: 0)
                backgroundView?.removeFromSuperview()
                backgroundView = nil
                loadedCards.remove(at: 0)
                forgroundView?.removeFromSuperview()
                forgroundView = nil
                loadedCards.remove(at: 0)
                anotherView?.removeFromSuperview()
                anotherView = nil
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            }
            if self.aBusinessTileOperator == nil
            {
                self.aBusinessTileOperator = BusinessTileOperator(city: yelpContainer.getCity(), state: yelpContainer.getState(), coordinate: self.theCoordinate)
                self.aBusinessTileOperator.addBusinesses(arrayOfBusinesses: yelpContainer.getBusinesses())
                
                self.arrayOfBusinesses = self.aBusinessTileOperator.obtainBusinessesForCards()
                for i in 0..<self.arrayOfBusinesses.count
                {
                    let radiusCoreData = RadiusCoreData()
                    let isEmpty = radiusCoreData.checkIfCoreDataIsEmpty()
                    let radius = radiusCoreData.loadRadius()
                    
                    if appDelegate.isLocationEnabled() == true && i < self.arrayOfBusinesses.count
                    {
                        let radiusCoreData = RadiusCoreData()
                        if isEmpty == false && radiusCoreData.loadRadius() != 0 &&  self.arrayOfBusinesses[i].getDistance() >= radius
                        {
                            self.arrayOfBusinesses.remove(at: i)
                        }
                    }
                }
            }
            else
            {
                self.aBusinessTileOperator.setTheCoordinate(coordinate: self.theCoordinate)
                self.aBusinessTileOperator.addBusinesses(arrayOfBusinesses: yelpContainer.getBusinesses())
                self.arrayOfBusinesses = self.aBusinessTileOperator.obtainBusinessesForCards()
                let radiusCoreData = RadiusCoreData()
                let radius = radiusCoreData.loadRadius()
                let isEmpty = radiusCoreData.checkIfCoreDataIsEmpty()
                for i in 0..<self.arrayOfBusinesses.count
                {
                    if appDelegate.isLocationEnabled() == true && i < self.arrayOfBusinesses.count
                    {
                        
                        if isEmpty == false && self.arrayOfBusinesses[i].getDistance() >= radius
                        {
                            self.arrayOfBusinesses.remove(at: i)
                        }
                    }
                }
            }
            if radiusIndex != 0
            {
                radiusIndex -= 1
            }
            if radiusIndex == 0
            {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.leftButton.isEnabled = true
                self.rightButton.isEnabled = true
                self.infoButton.isEnabled = true
                self.loadCards()
            }
        }
        else
        {
            if radiusIndex != 0
            {
                radiusIndex -= 1
            }
            if radiusIndex == 0
            {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.leftButton.isEnabled = true
                self.rightButton.isEnabled = true
                self.infoButton.isEnabled = true
                self.loadCards()
            }
        }
    }
    
    func placeFound(place: String, radiiDistances: RadiiDistances) {
        self.activityIndicator.isHidden = false
        self.leftButton.isEnabled = false
        self.rightButton.isEnabled = false
        self.infoButton.isEnabled = false
        self.activityIndicator.startAnimating()
        if !self.isPlaceAlreadyInArray(place: place)
        {
            self.addToArrayOfPlaces(place: place)
        }        
    }
    
    func finishedQuerying(radiiDistances: RadiiDistances) {
        radiusIndex = 0
        for place in self.arrayOfPlaces
        {
            self.yelpContainer = nil
            
            self.yelpContainer = YelpContainer(cityAndState: place)
            self.yelpContainer?.changeGenre(genre: self.getGenre())
            self.yelpContainer?.delegate = self
            self.yelpContainer?.yelpAPICallForBusinesses()
            radiusIndex += 1
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
            
            self.personalBusinessCoreData = PersonalBusinessCoreData(coordinate: self.theCoordinate)
            self.personalBusinessCoreData.resetCoreData()
            
            let radiusCoreData = RadiusCoreData()
            if !radiusCoreData.checkIfCoreDataIsEmpty()
            {
                let distance = radiusCoreData.loadRadius()
                self.arrayOfPlaces.removeAll()
                self.radiiDistances = RadiiDistances(latitude: self.theCoordinate.latitude, longitude: self.theCoordinate.longitude, distance: Double(distance))
                self.radiiDistances.delegate = self
                
                if distance == 0
                {
                    self.radiiDistances.callDelegate()
                }
                self.radiiDistances.calculateForDistance(distance: Double(distance))
                
            }
            else
            {
                self.yelpContainer = nil
                self.yelpContainer = YelpContainer(cityAndState: appDelegate.getCityAndState())
                self.yelpContainer?.delegate = self
                self.yelpContainer?.yelpAPICallForBusinesses()
            }
            self.initialCallWasCalled()
            
            self.setCityState(cityState: appDelegate.getCityAndState())
            self.setTheCoordinate(coordinate: appDelegate.getCoordinate())
            
        }
    }
}

extension BusinessTileViewController : GMSAutocompleteViewControllerDelegate
{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        if !loadedCards.isEmpty
        {
            backgroundView?.isHidden = true
            forgroundView?.isHidden = true
            anotherView?.isHidden = true
            loadedCards.remove(at: 0)
            backgroundView?.removeFromSuperview()
            backgroundView = nil
            loadedCards.remove(at: 0)
            forgroundView?.removeFromSuperview()
            forgroundView = nil
            loadedCards.remove(at: 0)
            anotherView?.removeFromSuperview()
            anotherView = nil
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
        self.arrayOfBusinesses.removeAll()
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
        self.leftButton.isEnabled = false
        self.rightButton.isEnabled = false
        self.infoButton.isEnabled = false
        self.activityIndicator.startAnimating()
        dismiss(animated: true, completion: nil)
        
        
        //UISearchBar.appearance().tintColor = UIColor.white
        //UISearchBar.appearance().backgroundColor = UIColor.red
        //UISearchBar.appearance().setSearchImageColor = UIColor.white
        //UINavigationBar.appearance().barTintColor = UIColor.white
        //UINavigationBar.appearance().tintColor = UIColor.white
      
        
        
        /*
        open var tableCellBackgroundColor: UIColor
        
        open var tableCellSeparatorColor: UIColor
        
        open var primaryTextColor: UIColor
        
        open var primaryTextHighlightColor: UIColor
        
        open var secondaryTextColor: UIColor
        
        open var tintColor: UIColor?
         
         navigationItem.rightBarButtonItem = UIBarButtonItem(customView: (searchController?.searchBar)!)
         
         [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
         setBackgroundImage:myNavBarButtonBackgroundImage forState:state barMetrics:metrics];
         */
        
        
        
        //self.title = "Discover"
        //self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightBold), NSForegroundColorAttributeName: UIColor.white]
        
        
        
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

public extension UISearchBar {
    
    public func setNewcolor(color: UIColor) {
        let clrChange = subviews.flatMap { $0.subviews }
        guard let sc = (clrChange.filter { $0 is UITextField }).first as? UITextField else { return }
        sc.textColor = color
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
