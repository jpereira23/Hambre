//
//  FirstPageViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 7/13/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import CoreLocation
protocol FirstPageViewControllerDelegate
{
    func nextButtonWasClicked()
    func skipButtonWasClicked()
}
class FirstPageViewController: UIViewController {

    @IBOutlet var controlSegment: UIPageControl!
    @IBOutlet var imageView: UIImageView!
    
    var delegate : FirstPageViewControllerDelegate?
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controlSegment.currentPage = 1

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func nextButton(_ sender: Any) {
        self.delegate?.nextButtonWasClicked()
    }

    
    @IBAction func skipButton(_ sender: Any) {
        self.delegate?.skipButtonWasClicked()
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
