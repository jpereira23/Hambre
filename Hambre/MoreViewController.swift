//
//  MoreViewController.swift
//  Hambre
//
//  Created by Waldo on 7/18/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import SafariServices

class MoreViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
        
    }
    
    @IBAction func rateUsPressed(_ sender: Any) {
        let link = SFSafariViewController(url: URL(string: "https://itunes.apple.com/us/app/clash-royale/id1053012308?mt=8")!)
        self.present(link, animated: true, completion: nil)
    }
    
    
    @IBAction func shareUsPressed(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: ["Make your life easier by finding out where to go eat next by using the Zendish app today. Available in the app store."], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }



}
