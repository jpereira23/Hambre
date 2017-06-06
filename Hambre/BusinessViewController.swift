//
//  BusinessViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/31/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class BusinessViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataWarning: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var imageUrl : URL!
    public var cloudKitDatabaseHandler = CloudKitDatabaseHandler()
    //public var realmDatabaseHandler = RealmDatabaseHandler()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.setImageWith(self.imageUrl)
        self.noDataWarning.isHidden = true
        self.tableView.isHidden = true
        self.cloudKitDatabaseHandler.delegate = self
        self.activityIndicator.startAnimating()
        //let anArray = self.cloudKitDatabaseHandler.accessArrayOfReviews()
        
        
        //if self.realmDatabaseHandler.loadRealmDatabase().count == 0
        //{
//            self.tableView.isHidden = true
//            self.noDataWarning.isHidden = false
//        }
        
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
        self.tableView.reloadData()
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
}

extension BusinessViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let array = self.filterArray(anId: self.getURL())
        cell.textLabel!.text = String(array[indexPath.row].getReview()) + "   - By, " + array[indexPath.row].getReviewer()
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
