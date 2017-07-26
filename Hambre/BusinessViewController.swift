//
//  BusinessViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/31/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import YelpAPI
import CloudKit
import CoreLocation
import SafariServices

class BusinessViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var addReviewButton: UIButton!
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var segmentView: UIView!
    
    
    private var imageUrl : URL!
    private var identifyingProperty : String! = ""
    public var longitude : Double!
    public var latitude : Double!
    public var cloudKitDatabaseHandler = CloudKitDatabaseHandler()
    private var phoneNumber : String!
    private var isClosed : Bool!
    private var address : String!
    private var websiteUrl : String!
    private var aTitle : String!
    private var distance : Int = 0
    private var reviewView : ReviewView!
    private var detailView : DetailView!
    private var mapView : MapView!
    
    
    private var currentView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        //self.navigationItem.title = self.aTitle
        
        
        //self.cloudKitDatabaseHandler.delegate = self
        
        self.detailView = DetailView(frame: CGRect(x: 0, y: 0, width: self.segmentView.frame.width, height: self.segmentView.frame.height))
        self.detailView.setAddressField(address: self.address)
        self.detailView.setPhoneField(phone: self.phoneNumber)
        self.detailView.setIsClosed(isClosed: self.isClosed)
        self.detailView.setWebsiteUrl(url: self.websiteUrl)
        self.detailView.setTitle(title: self.aTitle)
        self.detailView.xibSetUp()
        self.detailView.websiteUrlField.addTarget(self, action: #selector(getWebsiteButtonTriggered(sender:)), for: UIControlEvents.touchDown)
        self.detailView.phoneFIeld.addTarget(self, action: #selector(phoneButtonHasBeenTriggered(sender:)), for: UIControlEvents.touchDown)
        self.detailView.directionsButton.addTarget(self, action: #selector(directionsButtonTriggered(sender:)), for: UIControlEvents.touchDown)
        self.currentView = self.detailView.getView()
        self.segmentView.addSubview(self.currentView)
        
        
        if self.latitude != 6666.0
        {
            let camera = GMSCameraPosition.camera(withLatitude: self.latitude, longitude: self.longitude, zoom: 16.5)
            let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y:0, width: self.segmentView.frame.width, height: self.segmentView.frame.height), camera: camera)
            
            self.view.addSubview(mapView)
            mapView.translatesAutoresizingMaskIntoConstraints = false
            
            let leftCons = NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
            let rightCons = NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
            let topCons = NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
            let mapHeight = NSLayoutConstraint(item: mapView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0, constant: 190)
            
            let bottom = NSLayoutConstraint(item: bottomLayoutGuide, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 394)
            
            
            view.addConstraints([leftCons, rightCons, topCons, mapHeight, bottom])
            

            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
            marker.title = self.aTitle
            marker.snippet = String(self.distance) + " mi"
            marker.map = mapView
        }
        else
        {
            detailView.directionsButton.isEnabled = false 
            let camera = GMSCameraPosition.camera(withLatitude: -76.295604, longitude: 22.319117, zoom: 16.5)
            let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y:0, width: self.segmentView.frame.width, height: self.segmentView.frame.height), camera: camera)
            self.view.addSubview(mapView)
            
            mapView.translatesAutoresizingMaskIntoConstraints = false
            
            let leading = NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
            
            let trailing = NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
            
            let top = NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
            
            let mapHeight = NSLayoutConstraint(item: mapView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0, constant: 209)
            
            let bottom = NSLayoutConstraint(item: bottomLayoutGuide, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 394)
            
            
            view.addConstraints([leading, trailing, top, mapHeight, bottom])
            

            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: -76.295604, longitude: 22.319117)
            marker.title = "This restaurants coordinates cannot be found"
            marker.snippet = "Miles not available"
            marker.map = mapView
        }
       

        
        //auto layout constraint
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let description = String(describing: navigationController!.viewControllers.first!.classForCoder)
        if description == "BusinessTileViewController"
        {
            let rootViewController = self.navigationController?.viewControllers.first as! BusinessTileViewController
            
            var reviews = 0
            
            for review in self.cloudKitDatabaseHandler.accessArrayOfReviews()
            {
                if review.getId() == imageUrl.absoluteString
                {
                    reviews += 1
                }
            }
            if rootViewController.loadedCards.count > 1
            {
                rootViewController.forgroundView?.reviewsField!.text = String(reviews) + ((reviews > 1 || reviews == 0) ? " reviews" : " review")
                rootViewController.forgroundView?.setAverageFloat(averageReviews: self.cloudKitDatabaseHandler.getAverageReviews(url: self.imageUrl.absoluteString))
            }
            else
            {
                rootViewController.backgroundView?.reviewsField!.text = String(reviews) + ((reviews > 1 || reviews == 0) ? " reviews" : " review")
                rootViewController.backgroundView?.setAverageFloat(averageReviews: self.cloudKitDatabaseHandler.getAverageReviews(url: self.imageUrl.absoluteString))
            }
        }
    }
    
    
    
    let regionRadius: CLLocationDistance = 1000
   /*
    private func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    */
    public func getURL() -> String
    {
        return self.imageUrl.absoluteString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func setUrl(aUrl: URL)
    {
        self.imageUrl = aUrl
    }
    
    public func setLongitude(longitude: Double)
    {
        self.longitude = longitude
    }
    
    public func setLatitude(latitude: Double)
    {
        self.latitude = latitude
    }
    
    public func setIdentifier(id: String)
    {
        self.identifyingProperty = id
    }
    
    public func setPhoneNumber(phone: String)
    {
        self.phoneNumber = phone 
    }
    
    public func setWebsiteUrl(url: String)
    {
        self.websiteUrl = url
    }
    
    public func setDistance(distance: Int)
    {
        self.distance = distance
    }
    
    public func setTitle(title: String)
    {
        self.aTitle = title
    }
    
    public func setIsClosed(isClosed: Bool)
    {
        self.isClosed = isClosed
    }
    
    public func setAddress(address: String)
    {
        self.address = address 
    }
    
    @IBAction func unwindToBusinessView(_ sender: UIStoryboardSegue)
    {
        self.segmentControl.selectedSegmentIndex = 0
        self.detailView = DetailView(frame: CGRect(x: 0, y: 0, width: self.segmentView.frame.width, height: self.segmentView.frame.height))
        self.detailView.setAddressField(address: self.address)
        self.detailView.setPhoneField(phone: self.phoneNumber)
        self.detailView.setIsClosed(isClosed: self.isClosed)
        self.detailView.setWebsiteUrl(url: self.websiteUrl)
        self.detailView.setTitle(title: self.aTitle)
        self.detailView.xibSetUp()
        self.detailView.websiteUrlField.addTarget(self, action: #selector(getWebsiteButtonTriggered(sender:)), for: UIControlEvents.touchDown)
        self.currentView = self.detailView.getView()
        self.segmentView.addSubview(self.currentView)
        self.reviewView.setArrayOfReviews(reviews: self.cloudKitDatabaseHandler.accessArrayOfReviews())
    }
    
    @IBAction func indexChanged(_ sender: Any)
    {
        self.currentView.removeFromSuperview()
        switch self.segmentControl.selectedSegmentIndex
        {
        case 0:
            self.detailView = DetailView(frame: CGRect(x: 0, y: 0, width: self.segmentView.frame.width, height: self.segmentView.frame.height))
            self.detailView.setAddressField(address: self.address)
            self.detailView.setPhoneField(phone: self.phoneNumber)
            self.detailView.setIsClosed(isClosed: self.isClosed)
            self.detailView.setWebsiteUrl(url: self.websiteUrl)
            self.detailView.setTitle(title: self.aTitle)
            self.detailView.xibSetUp()
            self.detailView.websiteUrlField.addTarget(self, action: #selector(getWebsiteButtonTriggered(sender:)), for: UIControlEvents.touchDown)
            self.detailView.phoneFIeld.addTarget(self, action: #selector(phoneButtonHasBeenTriggered(sender:)), for: UIControlEvents.touchDown)
            self.detailView.directionsButton.addTarget(self, action: #selector(directionsButtonTriggered(sender:)), for: UIControlEvents.touchDown)
            
            self.currentView = self.detailView.getView()
            self.segmentView.addSubview(self.currentView)
            
            break
        case 1:
            let average = self.cloudKitDatabaseHandler.getAverageReviews(url: self.imageUrl.absoluteString)
            self.reviewView = ReviewView(frame: CGRect(x: 0, y: 0, width: self.segmentView.frame.width, height: self.segmentView.frame.height), averageOfReviews: average)
            self.reviewView.setArrayOfReviews(reviews: self.cloudKitDatabaseHandler.accessArrayOfReviews())
            self.reviewView.setUrl(url: self.imageUrl.absoluteString)
            
            self.reviewView.setAverageReviews(averageReviews: average) 
            self.reviewView.xibSetUp()
            self.reviewView.addReviewButton.addTarget(self, action: #selector(addReviewButtonTriggered(sender:)), for: UIControlEvents.touchDown)
            
            self.currentView = self.reviewView.getView()
            self.segmentView.addSubview(currentView)
            
            
            break


        default:
            
            break
        }
    }
    
    func addReviewButtonTriggered(sender: UIButton)
    {
      
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addReviewViewController")
                        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func phoneButtonHasBeenTriggered(sender: UIButton)
    {
        self.phoneNumber = self.phoneNumber.replacingOccurrences(of: "+", with: "")
        print(self.phoneNumber)
        guard let number = URL(string: "tel://" + self.phoneNumber) else { return }
        UIApplication.shared.open(number)
    }
    
    func getWebsiteButtonTriggered(sender: UIButton)
    {
        if self.websiteUrl != nil
        {
            let link = SFSafariViewController(url: URL(string: self.websiteUrl)!)
            self.present(link, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Website not available.", message: "Due to the unfortunate circumstances this website is not available.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                
            })
            
            
            self.present(alert, animated: true)
            
        }
        /*
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addWebsiteViewController") as! WebViewController
        
        vc.setWebUrl(url: self.websiteUrl)
        
        self.navigationController?.pushViewController(vc, animated: true)
         */
    }
    
    
    func directionsButtonTriggered(sender: UIButton)
    {
        let regionDistance: CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(self.latitude, self.longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan:regionSpan.span)]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.aTitle
        mapItem.openInMaps(launchOptions: options)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    /*
    extension LikedBusinessesViewController : UITableViewDelegate
    {
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.arrayOfLikedBusinesses.count
        }
        
        public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
            return 95
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                self.personalBusinessCoreData.removeElementFromCoreData(businessName: self.arrayOfLikedBusinesses[indexPath.row].getBusinessName())
                self.arrayOfLikedBusinesses.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
        }
    }
    
    extension LikedBusinessesViewController : UITableViewDataSource
    {
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell") as! LikedTableViewCell
            
            //custom orange forward chevron for favorites
            let chevron = UIImage(named: "ForwardChevron")
            cell.accessoryType = .disclosureIndicator
            cell.accessoryView = UIImageView(image: chevron)
            
            
            
            
            
            cell.distanceField.text = ((appDelegate.isLocationEnabled()) ? String(self.arrayOfLikedBusinesses[indexPath.row].getDistance()) + " mi" : "N/A")
            cell.setAverageReview(averageReview: self.cloudKitDatabaseHandler.getAverageReviews(url: self.arrayOfLikedBusinesses[indexPath.row].getBusinessImage().absoluteString))
            cell.titleField.text = self.arrayOfLikedBusinesses[indexPath.row].getBusinessName()
            cell.setURL(url: self.arrayOfLikedBusinesses[indexPath.row].getBusinessImage())
            let reviewsArray = self.cloudKitDatabaseHandler.accessArrayOfReviews()
            let numOfReviews = self.filterArrayOfReviews(url: self.arrayOfLikedBusinesses[indexPath.row].getBusinessImage(), array: reviewsArray)
            
            if numOfReviews == 0
            {
                cell.amountOfReviewsField.text = "0 Reviews"
            }
            else
            {
                cell.amountOfReviewsField.text = ((numOfReviews > 1) ? String(numOfReviews) + " Reviews" : String(numOfReviews) + " Review")
            }
            return cell
        }
    }
    */
    
    
    
}
