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
    
    
    var arrayOfLikedBusinesses = [PersonalBusiness]()
    public var personalBusinessCoreData : PersonalBusinessCoreData!
    public var cloudKitDatabaseHandler = CloudKitDatabaseHandler()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.personalBusinessCoreData = PersonalBusinessCoreData(coordinate: appDelegate.getCoordinate())
        //personalBusinessCoreData.resetCoreData()
        self.cloudKitDatabaseHandler.delegate = self
        self.cloudKitDatabaseHandler.loadDataFromCloudKit()
        self.arrayOfLikedBusinesses = personalBusinessCoreData.loadCoreData()
        self.tableView.isHidden = true
        self.activityIndicator.startAnimating()
        
        //favorites title
        self.title = "Favorites"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightSemibold), NSForegroundColorAttributeName: UIColor.white]
        
        //custom back button
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "BackChevron")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "BackChevron")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        
        
        //tableView.reloadData()
        //let businessTileViewController = self.tabBarController!.viewControllers![1] as! BusinessTileViewController
        //businessTileViewController.delegate = self
        // Do any additional setup after loading the view.
            }
    
    public func setCoordinate(coordinate: CLLocationCoordinate2D)
    {
        self.coordinate = coordinate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("The LikedBusinessController is going to appear")
        self.arrayOfLikedBusinesses.removeAll()
        self.arrayOfLikedBusinesses = personalBusinessCoreData.loadCoreData()
        self.tableView.reloadData()
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
            self.tableView.setEditing(true, animated: true)
            self.isEdit = true
        }
        else
        {
            self.editButton.setTitle("Edit", for: UIControlState.normal)
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
        //businessViewController.imageView.setImageWith(self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getBusinessImage())
        
        /*
        let navigationViewController = segue.destination as! UINavigationController
        navigationViewController.navigationBar.topItem?.title = self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getBusinessName()
        let navBar = navigationViewController.navigationBar
        
        /*
         let backItem = UIBarButtonItem()
         backItem.title = "Back"
         navigationViewController.navigationItem.backBarButtonItem = backItem
         */
        
        navBar.topItem?.title = self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getBusinessName()
        navBar.tintColor = UIColor.white
        navBar.titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20.0), NSForegroundColorAttributeName: UIColor.white]

        
        //navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navBar.barTintColor = UIColor(red: 0.98, green: 0.70, blue: 0.21, alpha: 1.0)
        
        */
        let businessViewController = segue.destination as! BusinessViewController
        businessViewController.setUrl(aUrl: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getBusinessImage())
        businessViewController.setLongitude(longitude: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getLongitude())
        businessViewController.setLatitude(latitude: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getLatitude())
        businessViewController.setPhoneNumber(phone: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getNumber())
        businessViewController.setAddress(address: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getFullAddress())
        businessViewController.setIsClosed(isClosed: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getIsClosed())
        businessViewController.setWebsiteUrl(url: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getWebsiteUrl())
        businessViewController.setTitle(title: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getBusinessName())
        
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
        return 80
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
        
        cell.distanceField.text = String(self.arrayOfLikedBusinesses[indexPath.row].getDistance()) + " mile(s)"
        
        cell.titleField.text = self.arrayOfLikedBusinesses[indexPath.row].getBusinessName()
        cell.setURL(url: self.arrayOfLikedBusinesses[indexPath.row].getBusinessImage())
        let reviewsArray = self.cloudKitDatabaseHandler.accessArrayOfReviews()
        let numOfReviews = self.filterArrayOfReviews(url: self.arrayOfLikedBusinesses[indexPath.row].getBusinessImage(), array: reviewsArray)
        
        if numOfReviews == 0
        {
            cell.amountOfReviewsField.text = "Be the first to review!"
        }
        else
        {
            cell.amountOfReviewsField.text = String(numOfReviews) + " Reviews"
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
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.tableView.isHidden = false
        self.tableView.reloadData()
        
    }
}
