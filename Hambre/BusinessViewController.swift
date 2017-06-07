//
//  BusinessViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/31/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import MapKit


class BusinessViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataWarning: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var reviewLabel: UILabel!
    @IBOutlet var addReviewButton: UIButton!
    @IBOutlet var segmentControl: UISegmentedControl!
    
    private var imageUrl : URL!
    public var longitude : Float!
    public var latitude : Float!
    public var cloudKitDatabaseHandler = CloudKitDatabaseHandler()
    //public var realmDatabaseHandler = RealmDatabaseHandler()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.setImageWith(self.imageUrl)
        self.noDataWarning.isHidden = true
        self.tableView.isHidden = true
        self.cloudKitDatabaseHandler.delegate = self
        self.activityIndicator.startAnimating()
        self.mapView.isHidden = true
        
        let initialLocation = CLLocation(latitude: Double(self.latitude), longitude: Double(self.longitude))
        self.centerMapOnLocation(location: initialLocation)
        
        //let anArray = self.cloudKitDatabaseHandler.accessArrayOfReviews()
        
        
        //if self.realmDatabaseHandler.loadRealmDatabase().count == 0
        //{
//            self.tableView.isHidden = true
//            self.noDataWarning.isHidden = false
//        }
        
    }
    
    let regionRadius: CLLocationDistance = 1000
    private func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
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
    
    public func setLongitude(longitude: Float)
    {
        self.longitude = longitude
    }
    
    public func setLatitude(latitude: Float)
    {
        self.latitude = latitude
    }
    
    public func filterArray(anId: String) -> [Review]
    {
        var reviews = [Review]()
        for review in self.cloudKitDatabaseHandler.accessArrayOfReviews()
        {
            let theId = review.getId()
            if theId == anId
            {
                reviews.append(review)
            }
        }
        return reviews
    }
    
    
    @IBAction func unwindToBusinessView(_ sender: UIStoryboardSegue)
    {
        sleep(3)
        self.cloudKitDatabaseHandler.loadDataFromCloudKit()
    }
    
    @IBAction func indexChanged(_ sender: Any)
    {
        switch self.segmentControl.selectedSegmentIndex
        {
        case 0:
            self.cloudKitDatabaseHandler.loadDataFromCloudKit()
            self.mapView.isHidden = true
            self.reviewLabel.isHidden = false
            self.tableView.isHidden = false
            self.addReviewButton.isHidden = false
            break
        case 1:
            self.mapView.isHidden = false
            self.reviewLabel.isHidden = true
            self.tableView.isHidden = true
            self.addReviewButton.isHidden = true
            break
        default:
            
            self.mapView.isHidden = true
            self.reviewLabel.isHidden = true
            self.tableView.isHidden = true
            self.addReviewButton.isHidden = true 
            break
        }
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
