//
//  MainTabViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/8/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

protocol MainTabViewControllerDelegate
{
    //func
}


class MainTabViewController: UITabBarController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //custom back button
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "BackChevron")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "BackChevron")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        
        //unselected tab bar icons = light gray
        self.tabBar.unselectedItemTintColor = UIColor(red: 188/255, green: 187/255, blue: 186/255, alpha: 1.0)
        
        //tab bar top border
        self.tabBar.layer.borderWidth = 0.50
        self.tabBar.layer.borderColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0).cgColor
        self.tabBar.clipsToBounds = true
        
        
        for viewController in self.viewControllers!        {
            print(viewController.classForCoder )
        
        }
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
