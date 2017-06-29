//
//  BusinessViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/31/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import MapKit
import YelpAPI

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
    internal var aTitle : String!
    
    private var currentView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.setImageWith(self.imageUrl)
        
        //self.cloudKitDatabaseHandler.delegate = self
        
        let detailView = DetailView(frame: CGRect(x: 0, y: 0, width: 352, height: 248))
        detailView.setAddressField(address: self.address)
        detailView.setPhoneField(phone: self.phoneNumber)
        detailView.setIsClosed(isClosed: self.isClosed)
        detailView.setWebsiteUrl(url: self.websiteUrl)
        detailView.xibSetUp()
        detailView.websiteUrlField.addTarget(self, action: #selector(getWebsiteButtonTriggered(sender:)), for: UIControlEvents.touchDown)
        self.currentView = detailView.getView()
        self.segmentView.addSubview(self.currentView)
        
        
        let initialLocation = CLLocation(latitude: Double(self.latitude), longitude: Double(self.longitude))
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
        sleep(2)
        self.cloudKitDatabaseHandler.loadDataFromCloudKit()
    }
    
    @IBAction func indexChanged(_ sender: Any)
    {
        self.currentView.removeFromSuperview()
        switch self.segmentControl.selectedSegmentIndex
        {
        case 0:
            let detailView = DetailView(frame: CGRect(x: 0, y: 0, width: self.segmentView.frame.width, height: self.segmentView.frame.height))
            detailView.setAddressField(address: self.address)
            detailView.setPhoneField(phone: self.phoneNumber)
            detailView.setIsClosed(isClosed: self.isClosed)
            detailView.setWebsiteUrl(url: self.websiteUrl)
            detailView.xibSetUp()
            detailView.websiteUrlField.addTarget(self, action: #selector(getWebsiteButtonTriggered(sender:)), for: UIControlEvents.touchDown)
            self.currentView = detailView.getView()
            self.segmentView.addSubview(self.currentView)
            
            break
        case 1:
            let reviewView = ReviewView(frame: CGRect(x: 0, y: 0, width: self.segmentView.frame.width, height: self.segmentView.frame.height))
            reviewView.setArrayOfReviews(reviews: self.cloudKitDatabaseHandler.accessArrayOfReviews())
            reviewView.setUrl(url: self.imageUrl.absoluteString)
            reviewView.xibSetUp()
            reviewView.addReviewButton.addTarget(self, action: #selector(addReviewButtonTriggered(sender:)), for: UIControlEvents.touchDown)
            self.currentView = reviewView.getView()
            self.segmentView.addSubview(currentView)
            
            
            break
            
        case 2:
            let mapView = MapView(frame: CGRect(x: 0, y: 0, width: self.segmentView.frame.width, height: self.segmentView.frame.height))
            mapView.setLatitude(latitude: self.latitude)
            mapView.setLongitude(longitude: self.longitude)
            mapView.setRestaurantTitle(restaurant: self.aTitle)
            mapView.xibSetUp()
            mapView.directionsButton.addTarget(self, action: #selector(directionsButtonTriggered(sender:)), for: UIControlEvents.touchDown)
            self.currentView = mapView.getView()
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
    
    func getWebsiteButtonTriggered(sender: UIButton)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addWebsiteViewController") as! WebViewController
        
        vc.setWebUrl(url: self.websiteUrl)
        
        self.navigationController?.pushViewController(vc, animated: true)
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

}

/*
extension BusinessViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array = self.filterArray(anId: self.getURL())
        return array.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 95
    }
}

extension BusinessViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ReviewTableViewCell
        let array = self.filterArray(anId: self.getURL())
        
        cell.nameField.text = array[indexPath.row].getReviewer()
        cell.commentField.text = array[indexPath.row].getSummaryReview()
        cell.reviewField.text = String(array[indexPath.row].getReview())

        return cell
    }
}

extension BusinessViewController : CloudKitDatabaseHandlerDelegate
{
    func errorUpdating(_ error: NSError) {
        print("Fuck off error")
    }

    func modelUpdated() {
        print("Working just not right format")
        
        let array = self.filterArray(anId: self.getURL())
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        if array.count == 0
        {
            self.noDataWarning.isHidden = false
        }
        else
        {
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}

extension BusinessViewController : MKMapViewDelegate
{
    /*
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotation : MKAnnotation!
        annotation.title = "Jeff"
        annotation.subtitle = "Pereira"
        annotation.coordinate.longitude = self.longitude
        annotation.coordinate.latitude = self.latitude
        
        var view: MKPinAnnotationView
        let identifier = "pin"
        if let dequeueView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        {
            dequeueView.annotation = MKAnnotation
        }
 
    }
     */
}
 */
