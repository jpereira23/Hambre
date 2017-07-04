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
    
    @IBOutlet var sliderLabel: UILabel!
    @IBOutlet var enterCityTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    private var cityState : String!
    private var sliderValue = 0
    @IBOutlet var slider: UISlider!
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.slider.maximumValue = 50
        self.slider.minimumValue = 1
        self.sliderLabel.text = String(self.sliderValue) + (self.sliderValue <= 1 ? " mile" : " miles")
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveButton.isEnabled = false
        self.slider.maximumValue = 500
        self.slider.minimumValue = 1
        
        //more view vc  THIS IS NOT WORKING FOR SOME REASON
        self.title = "More"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightSemibold), NSForegroundColorAttributeName: UIColor.white]
    }

    @IBAction func enterCityField(_ sender: Any)
    {
        let autocompleteController = GMSAutocompleteViewController()
        
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    public func setSliderValue(value: Int)
    {
        self.sliderValue = value
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
    
    let step: Float = 10
    
    @IBAction func sliderValueChanged(_ sender: Any) {
       
        
        let roundedValue = round((sender as! UISlider).value / step) * step
        (sender as! UISlider).value = roundedValue
        self.sliderValue = Int(roundedValue)
        self.sliderLabel.text = String(Int(roundf(roundedValue))) + ((Int(roundf(roundedValue))) <= 0 ? " mile" : " miles")
        self.saveButton.isEnabled = true 
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
            if self.cityState != nil
            {
                tileViewController.setCityState(cityState: self.cityState)
            }
            tileViewController.setDistance(distance:self.sliderValue)
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
