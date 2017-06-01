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
    
    private var imageUrl : URL!
    public var cloudKitDatabaseHandler = CloudKitDatabaseHandler()
    //public var realmDatabaseHandler = RealmDatabaseHandler()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.setImageWith(self.imageUrl)
        self.noDataWarning.isHidden = true
        self.cloudKitDatabaseHandler.delegate = self
        //let anArray = self.cloudKitDatabaseHandler.accessArrayOfReviews()
        
        //if self.realmDatabaseHandler.loadRealmDatabase().count == 0
        //{
//            self.tableView.isHidden = true
//            self.noDataWarning.isHidden = false
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func setUrl(aUrl: URL)
    {
        self.imageUrl = aUrl
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
        return self.cloudKitDatabaseHandler.accessArrayOfReviews().count
        return 0
    }
}

extension BusinessViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel!.text = self.cloudKitDatabaseHandler.accessArrayOfReviews()[indexPath.row].getReviewer()
        
        return cell
    }
}

extension BusinessViewController : CloudKitDatabaseHandlerDelegate
{
    func errorUpdating(_ error: NSError) {
        print("Fuck off error")
    }

    func modelUpdated() {
        print("The count of the global database is \(self.cloudKitDatabaseHandler.accessArrayOfReviews().count)")
        self.tableView.reloadData()
    }
}
