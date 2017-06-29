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
    private var cityState : String!
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
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToSettings(_ sender: UIStoryboardSegue)
    {
        
    }
    
    public func setCityState(cityState: String)
    {
        self.cityState = cityState
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "settingsToTile"
        {
            let tileViewController = segue.destination as! BusinessTileViewController
            tileViewController.setCityState(cityState: self.cityState)
        }
    }
    

}

extension SettingsViewController : GMSAutocompleteViewControllerDelegate
{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.setCityState(cityState: place.formattedAddress!)
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
