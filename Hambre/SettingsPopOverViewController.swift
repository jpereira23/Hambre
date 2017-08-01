//
//  SettingsPopOverViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 7/3/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import CoreLocation

class SettingsPopOverViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var currentLocationButton: UIButton!
    @IBOutlet weak var popView: UIView!
    @IBOutlet var cityStateLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var distanceSlider: UISlider!
    @IBOutlet var averageLabel: UILabel!
    public var locationImage : UIImage! 
    private var textForAverageLabel = "Distance"
    private var radiusCoreData = RadiusCoreData()
    private var indexOfSelectedCell = 0
    private var cityState : String!
    private var locationManager = CLLocationManager()
    
    private var sliderValue = 0
    let step: Float = 10
    var arrayOfGenres = ["All Restaurants", "Afghan", "African", "American", "Arabian", "Argentine", "Armenian", "Asian Fusion", "Australian", "Austrian", "Bangladeshi", "Barbeque", "Basque", "Belgian", "Brasseries", "Brazillian", "Breakfast & Brunch", "British", "Buffets", "Burgers", "Burmese", "Cafes", "Cafeteria", "Cajun/Creole", "Cambodian", "Caribbean", "Catalan", "Cheesesteaks", "Chicken Shop", "Chicken Wings", "Chinese", "Comfort Food", "Creperies", "Cuban", "Czech", "Delis", "Diners", "Dinner Theater", "Ethiopian", "Fast Food", "Filipino", "Fish & Chips", "Fondue", "Food Court", "Food Stands", "French", "Game Meat", "Gastropubs", "German", "Gluten-Free", "Greek", "Guamanian", "Halai", "Hawaiian", "Himalayan/Neplaese", "Honduran", "Hong Kong Style Cafe", "Hot Dogs", "Hot Pot", "Hungarian", "Iberian", "Indian", "Indonesian", "Irish", "Italian", "Japanese", "Kebab", "Korean", "Kosher", "Laotian", "Latin American", "Live/Raw Food", "Malaysian", "Mediterranean", "Mexican", "Middle Eastern", "Modern European", "Mongolian", "Moroccan",  "New Mexican Cafe", "Nicaraguan", "Noodles", "Pakistani", "Pan Asian", "Persian/Iranian", "Peruvian", "Pizza", "Polish", "Pop-Up Restaurants", "Portuguese", "Poutineries", "Russian", "Salad", "Sandwiches", "Scandinavian", "Scottish", "Seafood", "Singaporean", "Slovakian", "Soul Food", "Soup", "Southern", "Spanish", "Sri Lankan", "Steakhouses", "Supper Clubs", "Sushi Bars", "Syrian", "Taiwanese", "Tapas Bars", "Tapas/Small Plates", "Tex-Mex", "Thai", "Turkish", "Ukranian", "Uzbek", "Vegan", "Vegetarian", "Vietnamese", "Waffles", "Wraps"]
    
    
    override func viewWillAppear(_ animated: Bool) {
        if !radiusCoreData.checkIfCoreDataIsEmpty()
        {
            self.sliderValue = radiusCoreData.loadRadius()
        }
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.doneButton.frame
        rectShape.position = self.doneButton.center
        rectShape.path = UIBezierPath(roundedRect: self.doneButton.bounds, byRoundingCorners: [ .bottomLeft, .bottomRight], cornerRadii: CGSize(width: 5, height: 5)).cgPath
        self.doneButton.layer.mask = rectShape
        
        self.doneButton.isEnabled = false
        
       
        self.distanceSlider.maximumValue = 50
        self.distanceSlider.minimumValue = 1
        self.distanceSlider.setValue(Float(self.sliderValue), animated: false)
        self.distanceLabel.text = String(self.sliderValue) + (self.sliderValue <= 1 ? " mile" : " miles")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        self.cityStateLabel.text = self.cityState
        activityIndicator.isHidden = true
        
        // Do any additional setup after loading the view.
        
        popView.layer.shadowColor = UIColor.lightGray.cgColor
        popView.layer.shadowOffset = CGSize(width: 0, height: 2)
        popView.layer.shadowRadius = 2
        popView.layer.shadowOpacity = 0.75
        self.locationManager.delegate = self
        self.currentLocationButton.setImage(locationImage, for: .normal)
        
        
    }

    @IBAction func getCurrentLocation(_ sender: Any)
    {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled()
        {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startMonitoringSignificantLocationChanges()
            self.locationManager.startUpdatingLocation()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func setCityState(cityState: String)
    {
        self.cityState = cityState
    }
    
    public func setSelectedCell(index: Int)
    {
        self.indexOfSelectedCell = index
    }
    
    public func setSliderValue(value: Int)
    {
        self.sliderValue = value
    }
    
    public func getIndexOfSelectedCell() -> Int
    {
        return self.indexOfSelectedCell
    }
    
    
    
    @IBAction func sliderChangedValue(_ sender: Any)
    {
        self.doneButton.isEnabled = true
        let roundedValue = round((sender as! UISlider).value / step) * step
        (sender as! UISlider).value = roundedValue
        self.sliderValue = Int(roundedValue)
        self.distanceLabel.text = String(Int(roundf(roundedValue))) + ((Int(roundf(roundedValue))) <= 0 ? " mile" : " miles")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "settingsToTile"
        {
            let tileViewController = segue.destination as! BusinessTileViewController
            if self.cityState != nil
            {
                tileViewController.setCityState(cityState: self.cityState)
                tileViewController.setGenre(genre: self.arrayOfGenres[self.indexOfSelectedCell])
            }
            self.radiusCoreData.saveRadius(distance: self.sliderValue)
            tileViewController.setDistance(distance:self.sliderValue)
            tileViewController.setIndexOfSelectedGenre(index: self.indexOfSelectedCell)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let geoCoder = CLGeocoder()
        
        let location = CLLocation(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        currentLocationButton.isHidden = true
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            let placeMark : CLPlacemark! = placemarks![0]
            var aState : String! = ""
            var aCity : String! = ""
            
            if placeMark != nil
            {
                if let city = placeMark.addressDictionary?["City"] as? String {
                    aCity = city
                    print("City: \(city)")
                }
                
                if let state = placeMark.addressDictionary?["State"] as? String {
                    aState = state
                    print("State: \(state)")
                    
                    self.cityState = aCity + ", " + aState
                    self.cityStateLabel.text = self.cityState
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.currentLocationButton.setImage(UIImage(named: "fullglyph.png"), for: .normal)
                    self.currentLocationButton.isHidden = false
                    self.doneButton.isEnabled = true
                    self.currentLocationButton.isUserInteractionEnabled = false
                }
                
               
            }
            
            
            
        })
        self.locationManager.stopUpdatingLocation()
    }

}

extension SettingsPopOverViewController : UITableViewDelegate
{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfGenres.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.setSelectedCell(index: indexPath.row)
        self.tableView.reloadData()
        self.doneButton.isEnabled = true
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        self.setSelectedCell(index: 0)
        self.tableView.reloadData()
        
        
    }
}

extension SettingsPopOverViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        if indexPath.row == self.getIndexOfSelectedCell()
        {
            let orangeCircle = UIImage(named: "Picked")
            cell.accessoryType = .checkmark
            cell.accessoryView = UIImageView(image: orangeCircle)
            
        }
        else
        {
            cell.accessoryType = .none
            cell.accessoryView = nil
            
        }
        cell.textLabel?.text = self.arrayOfGenres[indexPath.row]
        
        return cell
    }
}

extension SettingsPopOverViewController : UITabBarDelegate
{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Jeff something was selected from tab bar")
    }
}
