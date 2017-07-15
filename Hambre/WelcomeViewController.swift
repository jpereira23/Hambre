//
//  WelcomeViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 7/15/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

protocol WelcomeViewControllerDelegate
{
    func skipWelcome()
    func nextWelcome()
}


class WelcomeViewController: UIViewController {
    
    @IBOutlet var pageControl: UIPageControl!
    var delegate : WelcomeViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageControl.currentPage = 0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func skipAction(_ sender: Any) {
        self.delegate.skipWelcome()
    }
    
    @IBAction func nextAction(_ sender: Any) {
        self.delegate.nextWelcome()
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
