//
//  FirstViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/28/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import YelpAPI
import BrightFutures

class FirstViewController: UIViewController {

    
    
    var businesses = [YLPBusiness]()
    @IBOutlet weak var tableView: UITableView!
    
    // Fill in your app keys here from
    // https://www.yelp.com/developers/v3/manage_app
    
    let appId = "M8_cEGzomTyCzwz3BDYY4Q"
    let appSecret = "9zi4Z5OMoP2NJMVKjLE5Yk0AzquHDWyIYgbblBaTW3sumGzu6LJZcJUdcMa1GfKD"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Search for 3 dinner restaurants
        let query = YLPQuery(location: "Tracy, CA")
        query.term = "mexican"
        query.limit = 50
        YLPClient.authorize(withAppId: appId, secret: appSecret).flatMap { client in
            client.search(withQuery: query)
            }.onSuccess { search in
                
                
                if let topBusiness = search.businesses.last {
                    self.businesses = search.businesses
                    
                    for aBusiness in search.businesses
                    {
                        print("Name: \(aBusiness.name) \n Image: \(String(describing: aBusiness.imageURL))")
                        
                    }
                    
                } else {
                    print("No businesses found")
                }
                //exit(EXIT_SUCCESS)
            }.onFailure { error in
                print("Search errored: \(error)")
                //exit(EXIT_FAILURE)
        }
        
    
        //dispatchMain()
 
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension FirstViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
}

extension FirstViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aCell")!
        cell.textLabel!.text = self.businesses[indexPath.row].name
        return cell
    }
}

