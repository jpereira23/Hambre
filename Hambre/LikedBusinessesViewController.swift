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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension LikedBusinessesViewController : UITableViewDelegate
{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfLikedBusinesses.count
    }
}

extension LikedBusinessesViewController : UITableViewDataSource
{
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel!.text = self.arrayOfLikedBusinesses[indexPath.row].getBusinessName()
        cell.textLabel!.textAlignment = .center

        return cell
    }
}

extension LikedBusinessesViewController : BusinessTileViewControllerDelegate
{
    func rightSwipeTriggered(_ businessTileViewController: BusinessTileViewController) {
        print("Working hopefully")
        self.tableView.reloadData()
    }
}
