//
//  NoInternetConnectionViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/29/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class NoInternetConnectionViewController: UIViewController {

    @IBOutlet var retryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if identifier == "noInternetToTile"
        {
            if appDelegate.isInternetAvailable()
            {
                return true
            }
        }
        
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "noInternetToTile"
        {
            let businessTileViewController = segue.destination as! BusinessTileViewController
            
        }
    }
    

}
