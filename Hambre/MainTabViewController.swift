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
        
        
        //
        //
        //
        //
        //
        //
        
        //let tileVC = BusinessTileViewController()
        //self.tabBar.items
        
        self.tabBar.unselectedItemTintColor = UIColor.init(red: 188/255, green: 187/255, blue: 186/255, alpha: 1.0)
        
        
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
