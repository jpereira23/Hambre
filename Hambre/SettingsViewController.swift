//
//  SettingsViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/7/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import GooglePlaces

class SettingsViewController: UIViewController, UISearchDisplayDelegate {

    @IBOutlet var searchBar: UISearchBar!
    var tableDataSource: GMSAutocompleteTableDataSource?
    @IBOutlet var aSearchDisplayController: UISearchDisplayController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableDataSource = GMSAutocompleteTableDataSource()
        self.tableDataSource?.delegate = self
        self.aSearchDisplayController.searchResultsDelegate = self.tableDataSource
        self.aSearchDisplayController.searchResultsDataSource = self.tableDataSource
        // Do any additional setup after loading the view.
    }
    
    func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.aSearchDisplayController.searchResultsTableView.reloadData()
    }
    
    func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.aSearchDisplayController.searchResultsTableView.reloadData()
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

extension SettingsViewController : GMSAutocompleteTableDataSourceDelegate
{
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        self.aSearchDisplayController.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool
    {
        return true
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        print("Error: \(error)")
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        return true
    }
    
    
}
