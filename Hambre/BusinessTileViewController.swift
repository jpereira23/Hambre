//
//  BusinessTileViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/29/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class BusinessTileViewController: UIViewController {

    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessImage: UIImageView!
    let aBusinessTileOperator = BusinessTileOperator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshTileAttributes()
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
    
    @IBAction func swipeLeft(_ sender: Any) {
        self.refreshTileAttributes()
    }
    
    @IBAction func swipeRight(_ sender: Any) {
        self.refreshTileAttributes()
    }
    
    private func refreshTileAttributes()
    {
        let aBusiness = self.aBusinessTileOperator.presentCurrentBusiness()
        if aBusiness != nil
        {
            self.businessNameLabel.text = aBusiness.getBusinessName()
            self.businessImage.image = aBusiness.getBusinessImage()
        }
    }

}
