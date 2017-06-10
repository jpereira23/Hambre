//
//  SettingsViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/7/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import GooglePlaces

class SettingsViewController: UIViewController {
    
    @IBOutlet var enterCityTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    
    private var coreDataLocation = CoreDataLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveButton.isEnabled = false
        self.tabBarController?.delegate = self
        
    }

    @IBAction func enterCityField(_ sender: Any)
    {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }

    @IBAction func savingLocation(_ sender: Any) {
        self.coreDataLocation.saveLocation(location: self.enterCityTextField.text!)
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

extension SettingsViewController : GMSAutocompleteViewControllerDelegate
{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.enterCityTextField.text = place.formattedAddress
        self.saveButton.isEnabled = true
        /*
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        */
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: \(error)")
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        return true
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension SettingsViewController : UITabBarControllerDelegate
{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if String(describing: viewController.classForCoder) == "BusinessTileViewController"
        {
            let businessTileViewController = viewController as! BusinessTileViewController
            businessTileViewController.cityRequiresRefresh()
        }
    }
}
