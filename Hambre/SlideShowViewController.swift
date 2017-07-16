//
//  SlideShowViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 7/13/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class SlideShowViewController: UIPageViewController, FirstPageViewControllerDelegate, SecondPageViewControllerDelegate, WelcomeViewControllerDelegate {

    
    public lazy var orderedViewControllers = [UIViewController]()
    public var appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        let wc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomePageController") as! WelcomeViewController
        wc.delegate = self
        orderedViewControllers.append(wc)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstPageController") as! FirstPageViewController
        vc.delegate = self
        orderedViewControllers.append(vc)
        let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondPageController") as! SecondPageViewController
        vc1.delegate = self
        orderedViewControllers.append(vc1)
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    func nextButtonWasClicked()
    {
        if appDelegate.isInternetAvailable()
        {
            appDelegate.configueCoordinates()
        }
        let vc = orderedViewControllers[2]
        setViewControllers([vc], direction: .forward, animated: true, completion: nil)
    }
    
    func skipButtonWasClicked()
    {
        if appDelegate.isInternetAvailable()
        {
            appDelegate.configueCoordinates()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func secondNextButton()
    {
        if appDelegate.isInternetAvailable()
        {
            appDelegate.configueCoordinates()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func skipWelcome()
    {
        if appDelegate.isInternetAvailable()
        {
            appDelegate.configueCoordinates()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func nextWelcome()
    {
        if appDelegate.isInternetAvailable()
        {
            appDelegate.configueCoordinates()
        }
        let vc = orderedViewControllers[1]
        setViewControllers([vc], direction: .forward, animated: true, completion: nil)
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

extension SlideShowViewController : UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
}
