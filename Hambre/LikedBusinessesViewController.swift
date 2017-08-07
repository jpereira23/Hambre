//
//  LikedBusinessesViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/30/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import CoreLocation

class LikedBusinessesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var editButton: UIButton!
    private var coordinate : CLLocationCoordinate2D!
    private var isEdit = false
    
    
    let chevron = UIImage(named: "ForwardChevron")
    var arrayOfLikedBusinesses = [PersonalBusiness]()
    var arrayOfImages = [UIImage]()
    var arrayOfAverageReviews = [Int]()
    public var personalBusinessCoreData : PersonalBusinessCoreData!
    public var cloudKitDatabaseHandler = CloudKitDatabaseHandler()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.personalBusinessCoreData = PersonalBusinessCoreData(coordinate: appDelegate.getCoordinate())
        //personalBusinessCoreData.resetCoreData()
        /*
        self.cloudKitDatabaseHandler.delegate = self
        self.cloudKitDatabaseHandler.loadDataFromCloudKit()
        self.tableView.isHidden = true
        self.activityIndicator.startAnimating()
        */
        //favorites title
        self.title = "Favorites"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightSemibold), NSForegroundColorAttributeName: UIColor.white]
        
        //custom back button
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "BackChevron")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "BackChevron")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        
        //helps not display empty cells
        tableView.tableFooterView = UIView()
        
    
        }
    
    
    public func setCoordinate(coordinate: CLLocationCoordinate2D)
    {
        self.coordinate = coordinate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.arrayOfLikedBusinesses.removeAll()
        /// if things dont work put copy and pasted code here
        
        self.cloudKitDatabaseHandler.delegate = self
        self.cloudKitDatabaseHandler.loadDataFromCloudKit()
        self.tableView.isHidden = true
        self.activityIndicator.startAnimating()
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.arrayOfLikedBusinesses.removeAll()
        self.arrayOfImages.removeAll()
        self.personalBusinessCoreData.deinitImagesArray()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editCells(_ sender: Any)
    {
        if !self.isEdit
        {
            self.editButton.setTitle("Cancel", for: UIControlState.normal)
            self.editButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightSemibold)
            self.tableView.setEditing(true, animated: true)
            self.isEdit = true
            
            //self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightSemibold), NSForegroundColorAttributeName: UIColor.white]
        }
        else
        {
            self.editButton.setTitle("Edit", for: UIControlState.normal)
            self.editButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightRegular)
            self.tableView.setEditing(false, animated: true)
            self.isEdit = false
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let businessViewController = segue.destination as! BusinessViewController
        businessViewController.setUrl(aUrl: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getBusinessImage()!)
        businessViewController.setLongitude(longitude: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getLongitude())
        businessViewController.setLatitude(latitude: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getLatitude())
        businessViewController.setPhoneNumber(phone: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getNumber())
        businessViewController.setAddress(address: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getFullAddress())
        businessViewController.setIsClosed(isClosed: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getIsClosed())
        businessViewController.setWebsiteUrl(url: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getWebsiteUrl())
        businessViewController.setTitle(title: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getBusinessName())
        businessViewController.setDistance(distance: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getDistance())
        
        //businessViewController.imageView.setImageWith(self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getBusinessImage())
        
    }
    
    public func filterArrayOfReviews(url: URL, array: [Review]) -> Int
    {
        let stringUrl = url.absoluteString
        var tmpArray = [Review]()
        
        for review in array
        {
            if review.getId() == stringUrl
            {
                tmpArray.append(review)
            }
        }
        
        return tmpArray.count
    }
    
    @IBAction func unwindFromBusinessView(_ sender: UIStoryboardSegue)
    {
        
    }

}

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
            self.arrayOfAverageReviews.remove(at: indexPath.row)
            self.arrayOfImages.remove(at: indexPath.row)
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
        
        cell.accessoryType = .disclosureIndicator
        cell.accessoryView = UIImageView(image: chevron)
        
        //cell.distanceField.text = ((appDelegate.isLocationEnabled()) ? String(self.arrayOfLikedBusinesses[indexPath.row].getDistance()) + " mi" : "N/A")
        
        cell.distanceField.text = self.arrayOfLikedBusinesses[indexPath.row].getCity() + ", " + self.arrayOfLikedBusinesses[indexPath.row].getState() 
        cell.setAverageReview(averageReview: self.cloudKitDatabaseHandler.getAverageReviews(url: (self.arrayOfLikedBusinesses[indexPath.row].getBusinessImage()?.absoluteString)!))
        cell.titleField.text = self.arrayOfLikedBusinesses[indexPath.row].getBusinessName()
        cell.setImage(image: self.arrayOfImages[indexPath.row])
        
        let numOfReviews = self.arrayOfAverageReviews[indexPath.row]
        
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

extension LikedBusinessesViewController : CloudKitDatabaseHandlerDelegate
{
    func errorUpdating(_ error: NSError) {
        print(error)
    }
    
    func modelUpdated() {
        self.arrayOfLikedBusinesses = personalBusinessCoreData.loadCoreData()
        let reviewsArray = self.cloudKitDatabaseHandler.accessArrayOfReviews()
        for business in self.arrayOfLikedBusinesses
        {
            if business.getBusinessImage() != nil
            {
                personalBusinessCoreData.downloadImagesForArrayOfImages(url: business.getBusinessImage()!)
                self.arrayOfAverageReviews.append(self.filterArrayOfReviews(url: business.getBusinessImage()!, array: reviewsArray))
            }
        }
        self.arrayOfImages = personalBusinessCoreData.getArrayOfImages()
       
        
        self.tableView.reloadData()
        self.tableView.isHidden = false
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        
    }
}
