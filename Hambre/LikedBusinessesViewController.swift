//
//  LikedBusinessesViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/30/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit


class LikedBusinessesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var arrayOfLikedBusinesses = [PersonalBusiness]()
    private var personalBusinessCoreData = PersonalBusinessCoreData()
    public var cloudKitDatabaseHandler = CloudKitDatabaseHandler()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //personalBusinessCoreData.resetCoreData()
        self.cloudKitDatabaseHandler.delegate = self
        self.cloudKitDatabaseHandler.loadDataFromCloudKit()
        self.arrayOfLikedBusinesses = personalBusinessCoreData.loadCoreData()
        self.tableView.isHidden = true
        self.activityIndicator.startAnimating()
        
        //tableView.reloadData()
        //let businessTileViewController = self.tabBarController!.viewControllers![1] as! BusinessTileViewController
        //businessTileViewController.delegate = self
        // Do any additional setup after loading the view.
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
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //businessViewController.imageView.setImageWith(self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getBusinessImage())
        

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
        
        let businessViewController = segue.destination.childViewControllers[0] as! BusinessViewController
        businessViewController.setUrl(aUrl: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getBusinessImage())
        businessViewController.setLongitude(longitude: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getLongitude())
        businessViewController.setLatitude(latitude: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getLatitude())
        businessViewController.setPhoneNumber(phone: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getNumber())
        businessViewController.setAddress(address: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getAddress())
        businessViewController.setIsClosed(isClosed: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getIsClosed())
        businessViewController.setWebsiteUrl(url: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getWebsiteUrl())
        
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
}

extension LikedBusinessesViewController : UITableViewDataSource
{
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LikedTableViewCell
    
        cell.distanceField!.text = String(self.arrayOfLikedBusinesses[indexPath.row].getDistance()) + " mile(s)"
        cell.titleField!.text = self.arrayOfLikedBusinesses[indexPath.row].getBusinessName()
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
