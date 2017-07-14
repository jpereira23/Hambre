//
//  SecondPageViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 7/13/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

protocol SecondPageViewControllerDelegate
{
    func secondNextButton()
}
class SecondPageViewController: UIViewController {

    @IBOutlet var controlSegment: UIPageControl!
    @IBOutlet var imageView: UIImageView!
    var delegate : SecondPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controlSegment.currentPage = 1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startSwiping(_ sender: Any) {
        self.delegate?.secondNextButton()
    }
    
    @IBAction func skipButton(_ sender: Any) {
        self.delegate?.secondNextButton()
    }
    
    @IBAction func nextButton(_ sender: Any) {
        self.delegate?.secondNextButton()
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
