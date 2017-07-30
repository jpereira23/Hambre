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
import SafariServices


class BusinessTileViewController: UIViewController, DraggableViewDelegate, YelpContainerDelegate, RadiiDistancesDelegate{
@IBOutlet weak var locationIcon: UIBarButtonItem!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessImage1: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet var infoButton: UIButton!
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var awesomeLine: UIImageView!
    
    @IBOutlet var GMSButton: UIButton!
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
    public var leftHasHappened = false
    public var launchedBefore : Bool! = true
    private var globalIndexForCurrentCompany = 0
    public var theCoordinate = CLLocationCoordinate2D(latitude: 37.787938, longitude: -122.407506)
    private var initialCall = false
    public var cloudKitDatabaseHandler = CloudKitDatabaseHandler()
    public var arrayOfReviews = [Review]()
    public var backgroundView : DraggableView?
    public var forgroundView : DraggableView?
    public var anotherView : DraggableView?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    public var radiusIndex = 0
    var MAX_BUFFER_SIZE: Int = 2
    @IBOutlet var outOfTiles: UIView!
    
    let maskView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.outOfTiles.isHidden = true
        //self.personalBusinessCoreData = PersonalBusinessCoreData(coordinate: theCoordinate)
        //self.personalBusinessCoreData.resetCoreData()
        appDelegate.delegate = self
        appDelegate.checkForLocationServices()
        self.cloudKitDatabaseHandler.delegate = self

        launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            leftHasHappened = true
            if appDelegate.isInternetAvailable()
            {
                appDelegate.configueCoordinates()
            }
        } else {
            print("First launch, setting UserDefault.")
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "slideShowView")
            self.present(viewController, animated:true, completion:nil)
            
        }

        
        if !appDelegate.isLocationEnabled()
        {
            let alert = UIAlertController(title: "Location Disabled", message: "Your Location is Disabled go to Settings > Zendish and enable them. Features of the app are currently limited.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                
            })
            
            
            self.present(alert, animated: true)
        }
        
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
        //maskView.image = UIImage(named: "Tile")
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
        
        self.GMSButton.setImage(UIImage(named: "LocationCircle.png"), for: .normal)
        self.GMSButton.setImage(UIImage(named: "CircleLocationPressed.png"), for: .highlighted)
    
        if !appDelegate.isInternetAvailable()
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "noInternetConnectionViewController")
            self.present(controller, animated: true, completion: nil)
        }
        
        //let navBorder: UIView = UIView(frame: CGRectMake(0, navigationController!.navigationBar.frame.size.height, navigationController!.navigationBar.frame.size.width, 1))
        
        //navBorder.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        //self.navigationController?.navigationBar.addSubview(navBorder)
        
    }
    
    //func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    //        return CGRect(x: x, y: y, width: width, height: height)
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    
    func cardSwipedLeft(_ card: UIView) {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore && !leftHasHappened{
            leftHasHappened = true
            let alert = UIAlertController(title: nil, message: "You have disliked your first restaurant. We appreciate your honesty!", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                // perhaps use action.title here
            })
            
            self.present(alert, animated: true)
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
        }
        
        if self.arrayOfBusinesses.count != 1 || self.arrayOfBusinesses.count != 0
        {
            loadedCards.remove(at: 0)
            backgroundView?.removeFromSuperview()
            backgroundView = nil
            loadedCards.remove(at: 0)
            forgroundView?.removeFromSuperview()
            forgroundView = nil
            
        }
        else
        {
            let aView = self.createDraggableViewWithData(at: 0)
            loadedCards.append(aView)
            loadedCards[0]?.xibSetUp()
            backgroundView = loadedCards[0]?.getView() as? DraggableView
            backgroundView?.frame.origin.x = 25
            backgroundView?.frame.origin.y = 86
            backgroundView?.backgroundColor = UIColor.white
            self.view.addSubview(backgroundView!)
            backgroundView!.delegate = self
            //let gestureRec = UITapGestureRecognizer(target: self, action: #selector(self.tapDetailViewForBusinessView(sender:)))
            
            //backgroundView?.addGestureRecognizer(gestureRec)
            setConstraintsOfBackgroundView()
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
                backgroundView?.backgroundColor = UIColor.white
                self.view.addSubview(backgroundView!)
                
                //let gestureRec = UITapGestureRecognizer(target: self, action: #selector(self.tapDetailViewForBusinessView(sender:)))
                
                //backgroundView?.addGestureRecognizer(gestureRec)
                backgroundView!.delegate = self
                setConstraintsOfBackgroundView()
            }
            else
            {
                self.globalIndexForCurrentCompany += 1
                if self.globalIndexForCurrentCompany + 1 >= self.arrayOfBusinesses.count
                {
                    self.globalIndexForCurrentCompany = 0
                }
                
                let aView = self.createDraggableViewWithData(at: self.globalIndexForCurrentCompany + 1)
                let aView1 = self.createDraggableViewWithData(at: self.globalIndexForCurrentCompany)
                loadedCards.append(aView)
                loadedCards.append(aView1)
                loadedCards[0]?.xibSetUp()
                loadedCards[1]?.xibSetUp()
                backgroundView = loadedCards[0]?.getView() as? DraggableView
                forgroundView = loadedCards[1]?.getView() as? DraggableView
                backgroundView?.frame.origin.x = 25
                forgroundView?.frame.origin.x = 25
                backgroundView?.frame.origin.y = 86
                forgroundView?.frame.origin.y = 86
                backgroundView?.backgroundColor = UIColor.white
                forgroundView?.backgroundColor = UIColor.white
                //forgroundView?.yelpButton.addTarget(self, action: #selector(yelpLinkAction(sender:)), for: UIControlEvents.touchDown)
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(yelpLinkAction(sender:)))
                forgroundView?.yelpAccess.addGestureRecognizer(tapGesture)
                
                self.view.addSubview(backgroundView!)
                self.view.insertSubview(forgroundView!, aboveSubview:backgroundView!)
                //let gestureRec = UITapGestureRecognizer(target: self, action: #selector(self.tapDetailViewForBusinessView(sender:)))
                forgroundView!.delegate = self
                //forgroundView?.addGestureRecognizer(gestureRec)
                setConstraintsOfBackgroundView()
                setConstraintsForForgroundView()
                //setConstraintsForAnotherView()
            }
        }
    }
    
    func cardSwipedRight(_ card: UIView) {
        
        if self.personalBusinessCoreData.checkIfCoreDataIsEmpty()
        {
            let alert = UIAlertController(title: "First Liked Restaurant", message: "You have liked your first restaurant! Now you can go to the Favorites tab to view your liked restaurant.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                // perhaps use action.title here
            })
            
            self.present(alert, animated: true)
        }
        
        if self.arrayOfBusinesses.count == 1
        {
            self.personalBusinessCoreData.saveBusiness(personalBusiness: (loadedCards[0]?.getBusiness())!)
            self.arrayOfBusinesses.remove(at: 0)
            self.outOfTiles.isHidden = false
        }
        else if self.arrayOfBusinesses.count != 0
        {
            self.personalBusinessCoreData.saveBusiness(personalBusiness: (loadedCards[1]?.getBusiness())!)
            self.arrayOfBusinesses.remove(at: self.globalIndexForCurrentCompany)
        }
        else
        {
            backgroundView?.removeFromSuperview()
        }
       
        
        if self.arrayOfBusinesses.count != 0
        {
            loadedCards.remove(at: 0)
            backgroundView?.removeFromSuperview()
            backgroundView = nil
            loadedCards.remove(at: 0)
            forgroundView?.removeFromSuperview()
            forgroundView = nil
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
                backgroundView?.backgroundColor = UIColor.white
                self.view.addSubview(backgroundView!)
                
                let gestureRec = UITapGestureRecognizer(target: self, action: #selector(self.tapDetailViewForBusinessView(sender:)))
                
                backgroundView?.addGestureRecognizer(gestureRec)
                backgroundView!.delegate = self
                setConstraintsOfBackgroundView()
                
            }
            else
            {
                if self.globalIndexForCurrentCompany + 1 >= self.arrayOfBusinesses.count
                {
                    self.globalIndexForCurrentCompany = 0
                }
                
                let aView = self.createDraggableViewWithData(at: self.globalIndexForCurrentCompany + 1)
                let aView1 = self.createDraggableViewWithData(at: self.globalIndexForCurrentCompany)
                loadedCards.append(aView)
                loadedCards.append(aView1)
                loadedCards[0]?.xibSetUp()
                loadedCards[1]?.xibSetUp()
                backgroundView = loadedCards[0]?.getView() as? DraggableView
                forgroundView = loadedCards[1]?.getView() as? DraggableView
                backgroundView?.frame.origin.x = 25
                forgroundView?.frame.origin.x = 25
                backgroundView?.frame.origin.y = 86
                forgroundView?.frame.origin.y = 86
                backgroundView?.backgroundColor = UIColor.white
                forgroundView?.backgroundColor = UIColor.white
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(yelpLinkAction(sender:)))
                forgroundView?.yelpAccess.addGestureRecognizer(tapGesture)
                self.view.addSubview(backgroundView!)
                self.view.insertSubview(forgroundView!, aboveSubview:backgroundView!)
                forgroundView!.delegate = self
                let gestureRec = UITapGestureRecognizer(target: self, action: #selector(self.tapDetailViewForBusinessView(sender:)))
                
                forgroundView?.addGestureRecognizer(gestureRec)
                setConstraintsOfBackgroundView()
                setConstraintsForForgroundView()
                //setConstraintsForAnotherView()
                //self.globalIndexForCurrentCompany += 1
            }
        }
    }
    
    private func createDraggableViewWithData(at index: Int) -> DraggableView {
        let draggableView = DraggableView(frame: CGRect(x: 25, y: 86, width: view.frame.width - 50, height: view.frame.height - 177), floatForStar: self.cloudKitDatabaseHandler.getAverageReviews(url: self.arrayOfBusinesses[index].getBusinessImage().absoluteString))
        
        draggableView.setBusinessName(name: self.arrayOfBusinesses[index].getBusinessName())
        draggableView.setImageUrl(url: self.arrayOfBusinesses[index].getBusinessImage())
        draggableView.setBusiness(business: self.arrayOfBusinesses[index])
        draggableView.setMiles(miles: ((appDelegate.isLocationEnabled()) ? String(self.arrayOfBusinesses[index].getDistance()) + " mi" : "N/A"))
        

        if self.arrayOfReviews.count > 0
        {
            let num = self.filterArrayOfReviews(url: self.arrayOfBusinesses[index].getBusinessImage())
            draggableView.setReviews(reviews: String(num) + ((num > 1 || num == 0) ? " reviews" : " review"))
        }
        else
        {
            draggableView.setReviews(reviews: "No reviews")
        }
        //draggableView.delegate = self
        
        return draggableView
    }
    
    func yelpLinkAction(sender: UIButton)
    {
        let link = SFSafariViewController(url: URL(string: "https://www.yelp.com")!)
        self.present(link, animated: true, completion: nil)
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
                backgroundView?.backgroundColor = UIColor.white
                //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(yelpLinkAction(sender:)))
                //backgroundView?.yelpButton.addGestureRecognizer(tapGesture)
                self.view.addSubview(backgroundView!)
                
                //let gestureRec = UITapGestureRecognizer(target: self, action: #selector(self.tapDetailViewForBusinessView(sender:)))
                //backgroundView?.addGestureRecognizer(gestureRec)
                
                setConstraintsOfBackgroundView()
                
            }
            else
            {
                if self.globalIndexForCurrentCompany + 1 >= self.arrayOfBusinesses.count
                {
                    self.globalIndexForCurrentCompany = 0
                }
                
                let aView = self.createDraggableViewWithData(at: self.globalIndexForCurrentCompany + 1)
                
                let aView1 = self.createDraggableViewWithData(at: self.globalIndexForCurrentCompany)
                
                loadedCards.append(aView)
                
                loadedCards.append(aView1)
                
                loadedCards[0]?.xibSetUp()
                
                
                loadedCards[1]?.xibSetUp()
                
                backgroundView = loadedCards[0]?.getView() as? DraggableView
                
                forgroundView = loadedCards[1]?.getView() as? DraggableView
                
                backgroundView?.frame.origin.x = 25
                forgroundView?.frame.origin.x = 25
                backgroundView?.frame.origin.y = 86
                
                
                forgroundView?.frame.origin.y = 86
                
                
                backgroundView?.backgroundColor = UIColor.white
                forgroundView?.backgroundColor = UIColor.white
                
                
                self.view.addSubview(backgroundView!)
                self.view.insertSubview(forgroundView!, aboveSubview:backgroundView!)
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(yelpLinkAction(sender:)))
                forgroundView?.yelpAccess.addGestureRecognizer(tapGesture)
                let gestureRec = UITapGestureRecognizer(target: self, action: #selector(self.tapDetailViewForBusinessView(sender:)))
                
                forgroundView?.addGestureRecognizer(gestureRec)
                forgroundView?.delegate = self 
                
                //auto layout
                
                
                setConstraintsOfBackgroundView()
                setConstraintsForForgroundView()
                
               
 
            }
            
        }
        else
        {
            self.outOfTiles.isHidden = false
        }
    }
    
    public func tapDetailViewForBusinessView(sender: UITapGestureRecognizer)
    {
        let businessViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "businessViewController") as! BusinessViewController
        
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
        
        self.navigationController?.pushViewController(businessViewController, animated: true)
        
        
    }
    
    public func setConstraintsOfBackgroundView()
    {
        backgroundView!.translatesAutoresizingMaskIntoConstraints =  false
        backgroundView!.imageView.translatesAutoresizingMaskIntoConstraints =  false
        
        
        let top = NSLayoutConstraint(item: backgroundView!, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 25)
        
        let leading = NSLayoutConstraint(item: backgroundView!, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 25)
        
        let trailing = NSLayoutConstraint(item: backgroundView!, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -25)
        
        let bottom = NSLayoutConstraint(item: backgroundView!, attribute: .bottom, relatedBy: .equal, toItem: awesomeLine, attribute: .top, multiplier: 1, constant: -8)
        
        let imageViewLeading = NSLayoutConstraint(item: backgroundView!.imageView, attribute: .leading, relatedBy: .equal, toItem: backgroundView!, attribute: .leading, multiplier: 1.0 , constant: 0)
        
         let height = NSLayoutConstraint(item: backgroundView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: view.frame.height - 177)
        
        let imageViewTrailing = NSLayoutConstraint(item: backgroundView!.imageView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 25)
        
        let imageViewBottom = NSLayoutConstraint(item: backgroundView!.imageView, attribute: .bottom, relatedBy: .equal, toItem: backgroundView!.businessNameField, attribute: .top, multiplier: 1.0, constant: -15)
        
        let imageViewTop = NSLayoutConstraint(item: backgroundView!.imageView, attribute: .top, relatedBy: .equal, toItem: backgroundView!, attribute: .top, multiplier: 1.0, constant: 0)
        
        backgroundView?.yelpAccess.translatesAutoresizingMaskIntoConstraints = false
        
        // Auto layout for yelpAccess
        let heightYelp1 = NSLayoutConstraint(item: backgroundView!.yelpAccess, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        let widthYelp1 = NSLayoutConstraint(item: backgroundView!.yelpAccess, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60)
        
        let bottomYelp1 = NSLayoutConstraint(item: backgroundView!.yelpAccess, attribute: .bottom, relatedBy: .equal, toItem: forgroundView!, attribute: .bottom, multiplier: 1.0, constant: -23)
        
        let trailingYelp1 = NSLayoutConstraint(item: backgroundView!.yelpAccess, attribute: .trailing, relatedBy: .equal, toItem: backgroundView!, attribute: .trailing, multiplier: 1, constant: -13)
        
        //backgroundView?.addConstraint(trailing1)
        view.addConstraints([top, leading, height, trailing, bottom, imageViewTrailing, imageViewLeading, imageViewBottom, imageViewTop, heightYelp1, widthYelp1, bottomYelp1, trailingYelp1])
    }
    
    public func setConstraintsForForgroundView()
    {
        forgroundView?.translatesAutoresizingMaskIntoConstraints = false
        forgroundView?.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: forgroundView!, attribute: .top, relatedBy: .equal, toItem: backgroundView!, attribute: .top, multiplier: 1.0, constant: 0)
        
        //let topYelpAccess = NSLayoutConstraint(item: forgroundView!.yelpAccess, attribute: .top, relatedBy: .equal, toItem: forgroundView!.imageView, attribute: .bottom, multiplier: 1.0, constant: 5.0)
        let leading = NSLayoutConstraint(item: forgroundView!, attribute: .leading, relatedBy: .equal, toItem: backgroundView!, attribute: .leading, multiplier: 1.0, constant: 0)
        
        let trailing = NSLayoutConstraint(item: forgroundView!, attribute: .trailing, relatedBy: .equal, toItem: backgroundView!, attribute: .trailing, multiplier: 1.0, constant: 0)
        
        let bottom = NSLayoutConstraint(item: forgroundView!, attribute: .bottom, relatedBy: .equal, toItem: backgroundView!, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        let height = NSLayoutConstraint(item: forgroundView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: view.frame.height - 177)
        
        let imageViewLeading = NSLayoutConstraint(item: forgroundView!.imageView, attribute: .leading, relatedBy: .equal, toItem: forgroundView!, attribute: .leading, multiplier: 1.0 , constant: 0)
        
        let imageViewTrailing = NSLayoutConstraint(item: forgroundView!.imageView, attribute: .trailing, relatedBy: .equal, toItem: backgroundView!, attribute: .trailing, multiplier: 1.0, constant: 50)
        
        // this originally was toItem: forgroundView!.businessNameField
        let imageViewBottom = NSLayoutConstraint(item: forgroundView!.imageView, attribute: .bottom, relatedBy: .equal, toItem: forgroundView!.businessNameField, attribute: .top, multiplier: 1.0, constant: -15)
        
        let imageViewTop = NSLayoutConstraint(item: forgroundView!.imageView, attribute: .top, relatedBy: .equal, toItem: forgroundView!, attribute: .top, multiplier: 1.0, constant: 0)
        
        forgroundView?.yelpAccess.translatesAutoresizingMaskIntoConstraints = false
        
        // Auto layout for yelpAccess
        let heightYelp = NSLayoutConstraint(item: forgroundView!.yelpAccess, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        let widthYelp = NSLayoutConstraint(item: forgroundView!.yelpAccess, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 60)
        
        let bottomYelp = NSLayoutConstraint(item: forgroundView!.yelpAccess, attribute: .bottom, relatedBy: .equal, toItem: forgroundView!, attribute: .bottom, multiplier: 1.0, constant: -23)
        
        let trailingYelp = NSLayoutConstraint(item: forgroundView!.yelpAccess, attribute: .trailing, relatedBy: .equal, toItem: forgroundView!, attribute: .trailing, multiplier: 1, constant: -13)
        
        //let heightMiles = NSLayoutConstraint(item: forgroundView!.milesField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15)
        
        
        view.addConstraints([heightYelp, widthYelp, bottomYelp, trailingYelp, top, leading, trailing, height, bottom, imageViewTrailing, imageViewLeading, imageViewBottom, imageViewTop])
    }
 
    /*
    public func isInitailCall() -> Bool
    {
        return self.initialCall
    }
    */
    
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
    
    /*
    public func initialCallWasCalled()
    {
        self.initialCall = true
    }
    */ 
    
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
        
        autocompleteController.searchDisplayController?.searchBar.tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = UIColor(red: 250/255, green: 178/255, blue: 53/255, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        
        let placeholderAttributes: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
        let attributedPlaceholder: NSAttributedString = NSAttributedString(string: "City, State or Zipcode", attributes: placeholderAttributes)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = attributedPlaceholder
        UISearchBar.appearance().setNewcolor(color: UIColor.white)
        UISearchBar.appearance().barStyle = UIBarStyle.default
        UISearchBar.appearance().tintColor = UIColor.white
        
        //autocompleteController.searchDisplayController?.searchBar.barTintColor = UIColor.red
        
        //Need to add placeholder color to white left
        
        // Color of the default search text.
        // NOTE: In a production scenario, "Search" would be a localized string
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func unwindToTileView(_ sender: UIStoryboardSegue)
    {
        if sender.identifier == "settingsToTile"
        {
            if loadedCards.count != 1 && loadedCards.count != 0
            {
                backgroundView?.isHidden = true
                forgroundView?.isHidden = true
                loadedCards.remove(at: 0)
                backgroundView?.removeFromSuperview()
                backgroundView = nil
                loadedCards.remove(at: 0)
                forgroundView?.removeFromSuperview()
                forgroundView = nil
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            }
            else if loadedCards.count == 1
            {
                backgroundView?.isHidden = true
                backgroundView?.removeFromSuperview()
                backgroundView = nil
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
            if loadedCards.count > 1
            {
                businessViewController.setUrl(aUrl: (loadedCards[1]!.getBusiness().getBusinessImage()))
                businessViewController.setLongitude(longitude: (loadedCards[1]!.getBusiness().getLongitude()))
                businessViewController.setLatitude(latitude: (loadedCards[1]!.getBusiness().getLatitude()))
                businessViewController.setPhoneNumber(phone: (loadedCards[1]!.getBusiness().getNumber()))
                businessViewController.setWebsiteUrl(url: (loadedCards[1]!.getBusiness().getWebsiteUrl()))
                businessViewController.setIsClosed(isClosed: (loadedCards[1]!.getBusiness().getIsClosed()))
                businessViewController.setAddress(address: (loadedCards[1]!.getBusiness().getFullAddress()))
                businessViewController.setTitle(title: (loadedCards[1]!.getBusiness().getBusinessName()))
                businessViewController.setDistance(distance: loadedCards[1]!.getBusiness().getDistance())
                
            }
            else
            {
                businessViewController.setUrl(aUrl: (loadedCards[0]!.getBusiness().getBusinessImage()))
                businessViewController.setLongitude(longitude: (loadedCards[0]!.getBusiness().getLongitude()))
                businessViewController.setLatitude(latitude: (loadedCards[0]!.getBusiness().getLatitude()))
                businessViewController.setPhoneNumber(phone: (loadedCards[0]!.getBusiness().getNumber()))
                businessViewController.setWebsiteUrl(url: (loadedCards[0]!.getBusiness().getWebsiteUrl()))
                businessViewController.setIsClosed(isClosed: (loadedCards[0]!.getBusiness().getIsClosed()))
                businessViewController.setAddress(address: (loadedCards[0]!.getBusiness().getFullAddress()))
                businessViewController.setTitle(title: (loadedCards[0]!.getBusiness().getBusinessName()))
                businessViewController.setDistance(distance: loadedCards[0]!.getBusiness().getDistance())
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
        /*
        if loadedCards.count != 1
        {
        loadedCards[1]?.xibSetUp()
        let dragView = loadedCards[1]!
        dragView.overlayView?.mode = .GGOverlayViewModeLeft
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            dragView.overlayView?.alpha = 1
            dragView.getView().transform = CGAffineTransform(scaleX: 11, y: 11)
        })
        dragView.leftClickAction()
        }
        else
        {
            loadedCards[0]?.xibSetUp()
            let dragView = loadedCards[0]!
            dragView.overlayView?.mode = .GGOverlayViewModeLeft
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                dragView.overlayView?.alpha = 1
                dragView.getView().transform = CGAffineTransform(scaleX: 11, y: 11)
            })
            dragView.leftClickAction()
        }
 
        */
        self.forgroundView?.delegate = nil
        self.leftButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {() -> Void in
            //self.forgroundView!.delegate = self
            //self.forgroundView!.center = CGPoint(x: -400, y: 100)
            //self.forgroundView?.transform = CGAffineTransform(scaleX: 11, y:11)
            
                //self.leftButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                //self.leftButton.transform = CGAffineTransform.identity
            
            self.leftButton.transform = CGAffineTransform.identity
           
        }, completion: nil)
    
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.forgroundView!.center = CGPoint(x: -400, y: 100)
            self.leftButton.isEnabled = false
            self.rightButton.isEnabled = false
        }, completion: {(_ complete: Bool) -> Void in
            self.leftButton.isEnabled = true
            self.rightButton.isEnabled = true
            self.forgroundView?.delegate = self
            self.forgroundView?.leftClickAction()
        })
        
        
    }
    
    @IBAction func swipeRight(_ sender: Any) {
        
        
        
        // still needs to be worked out after what i did for tileview
        
        /*
        if loadedCards.count != 1
        {
            loadedCards[1]?.xibSetUp()
            let dragView = loadedCards[1]!
            dragView.overlayView?.mode = .GGOverlayViewModeLeft
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                dragView.overlayView?.alpha = 1
                dragView.getView().transform = CGAffineTransform(scaleX: 11, y: 11)
            })
            dragView.rightClickAction()
        }
        else
        {
            loadedCards[0]?.xibSetUp()
            let dragView = loadedCards[0]!
            dragView.overlayView?.mode = .GGOverlayViewModeLeft
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                dragView.overlayView?.alpha = 1
                dragView.getView().transform = CGAffineTransform(scaleX: 11, y: 11)
            })
            dragView.rightClickAction()
        }
        */
        
        self.forgroundView?.delegate = nil
        
        self.rightButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {() -> Void in
            
        self.rightButton.transform = CGAffineTransform.identity
            
            //self.forgroundView!.delegate = self
            self.forgroundView!.center = CGPoint(x: 600, y: 100)
            //self.forgroundView?.transform = CGAffineTransform(scaleX: 11, y:11)
            self.leftButton.isEnabled = false
            self.rightButton.isEnabled = false
        }, completion: {(_ complete: Bool) -> Void in
            self.leftButton.isEnabled = true
            self.rightButton.isEnabled = true
            self.forgroundView?.delegate = self
            self.forgroundView?.rightClickAction()
        })
        
    }
    
    @IBAction func infoPressed(_ sender: Any) {
        
        self.infoButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {() -> Void in
            
            self.infoButton.transform = CGAffineTransform.identity
            
        }, completion: nil)
            
            
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
            
            
            if loadedCards.count != 1 && loadedCards.count != 0
            {
                backgroundView?.isHidden = true
                forgroundView?.isHidden = true
                loadedCards.remove(at: 0)
                backgroundView?.removeFromSuperview()
                backgroundView = nil
                loadedCards.remove(at: 0)
                forgroundView?.removeFromSuperview()
                forgroundView = nil
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            }
            else if loadedCards.count == 1
            {
                backgroundView?.isHidden = true
                backgroundView?.removeFromSuperview()
                backgroundView = nil
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
        
        if self.arrayOfBusinesses.count != 0
        {
            self.outOfTiles.isHidden = true
        }
        else
        {
            self.outOfTiles.isHidden = false
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
            usleep(200000)
            self.yelpContainer?.yelpAPICallForBusinesses()
            radiusIndex += 1
        }
    }

}

extension BusinessTileViewController : AppDelegateDelegate
{
    func locationServicesUpdated(appDelegate: AppDelegate) {
        
        self.aBusinessTileOperator = nil 
        if loadedCards.count != 1 && loadedCards.count != 0
        {
            backgroundView?.isHidden = true
            forgroundView?.isHidden = true
            loadedCards.remove(at: 0)
            backgroundView?.removeFromSuperview()
            backgroundView = nil
            loadedCards.remove(at: 0)
            forgroundView?.removeFromSuperview()
            forgroundView = nil
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
        else if loadedCards.count == 1
        {
            backgroundView?.isHidden = true
            backgroundView?.removeFromSuperview()
            backgroundView = nil
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
        //if !self.isInitailCall()
        //{
            self.setCityState(cityState: appDelegate.getCityAndState())
            self.setTheCoordinate(coordinate: appDelegate.getCoordinate())
            self.personalBusinessCoreData = PersonalBusinessCoreData(coordinate: self.theCoordinate)
            //self.personalBusinessCoreData.resetCoreData()
            
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
            //self.initialCallWasCalled()
            
            self.setCityState(cityState: appDelegate.getCityAndState())
            self.setTheCoordinate(coordinate: appDelegate.getCoordinate())
            
        //}
    }
}

extension BusinessTileViewController : GMSAutocompleteViewControllerDelegate
{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        if loadedCards.count != 1 && loadedCards.count != 0
        {
            backgroundView?.isHidden = true
            forgroundView?.isHidden = true
            loadedCards.remove(at: 0)
            backgroundView?.removeFromSuperview()
            backgroundView = nil
            loadedCards.remove(at: 0)
            forgroundView?.removeFromSuperview()
            forgroundView = nil
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
        else if loadedCards.count == 1
        {
            backgroundView?.isHidden = true
            backgroundView?.removeFromSuperview()
            backgroundView = nil
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
