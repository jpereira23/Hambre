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
    var arrayOfLikedBusinesses = [PersonalBusiness]()
    private var personalBusinessCoreData = PersonalBusinessCoreData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //personalBusinessCoreData.resetCoreData()
        self.arrayOfLikedBusinesses = personalBusinessCoreData.loadCoreData()
        tableView.reloadData()
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
        let navigationViewController = segue.destination as! UINavigationController
        navigationViewController.navigationBar.topItem?.title = self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getBusinessName()
        let businessViewController = segue.destination.childViewControllers[0] as! BusinessViewController
        businessViewController.setUrl(aUrl: self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getBusinessImage())
        //businessViewController.imageView.setImageWith(self.arrayOfLikedBusinesses[(self.tableView.indexPathForSelectedRow?.row)!].getBusinessImage())
        
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
        
        return cell
    }
}
