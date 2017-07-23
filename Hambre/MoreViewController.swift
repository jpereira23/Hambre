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
        
        //let navBorder: UIView = UIView(frame: CGRectMake(0, navigationController!.navigationBar.frame.size.height, navigationController!.navigationBar.frame.size.width, 1))
        
        //navBorder.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        //self.navigationController?.navigationBar.addSubview(navBorder)
        
        self.title = "More"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightBold), NSForegroundColorAttributeName: UIColor.white]
        
    }
    
    //func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    //        return CGRect(x: x, y: y, width: width, height: height)
    //    }
    
    @IBAction func rateUsPressed(_ sender: Any) {
        let link = SFSafariViewController(url: URL(string: "https://itunes.apple.com/us/")!)
        self.present(link, animated: true, completion: nil)
    }
    
    
    @IBAction func shareUsPressed(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: ["Make your life easier by finding out where to go eat next by using the Zendish app today. Available in the app store. goo.gl/ZrfhAi"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }



}
