//
//  SettingsPopOverViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 7/3/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class SettingsPopOverViewController: UIViewController {

    @IBOutlet var cityStateLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var distanceSlider: UISlider!
    @IBOutlet var averageLabel: UILabel!
    private var textForAverageLabel = "Distance"
    private var radiusCoreData = RadiusCoreData()
    private var indexOfSelectedCell = 0
    private var cityState : String!
    private var sliderValue = 0
    let step: Float = 10
    var arrayOfGenres = ["All Restaurants", "Afghan", "African", "American", "Arabian", "Argentine", "Armenian", "Asian Fusion", "Australian", "Austrian", "Bangladeshi", "Barbeque", "Basque", "Belgian", "Brasseries", "Brazillian", "Breakfast & Brunch", "British", "Buffets", "Burgers", "Burmese", "Cafes", "Cafeteria", "Cajun/Creole", "Cambodian", "Caribbean", "Catalan", "Cheesesteaks", "Chicken Shop", "Chicken Wings", "Chinese", "Comfort Food", "Creperies", "Cuban", "Czech", "Delis", "Diners", "Dinner Theater", "Ethiopian", "Fast Food", "Filipino", "Fish & Chips", "Fondue", "Food Court", "Food Stands", "French", "Game Meat", "Gastropubs", "German", "Gluten-Free", "Greek", "Guamanian", "Halai", "Hawaiian", "Himalayan/Neplaese", "Honduran", "Hong Kong Style Cafe", "Hot Dogs", "Hot Pot", "Hungarian", "Iberian", "Indian", "Indonesian", "Irish", "Italian", "Japanese", "Kebab", "Korean", "Kosher", "Laotian", "Latin American", "Live/Raw Food", "Malaysian", "Mediterranean", "Mexican", "Middle Eastern", "Modern European", "Mongolian", "Moroccan",  "New Mexican Cafe", "Nicaraguan", "Noodles", "Pakistani", "Pan Asian", "Persian/Iranian", "Peruvian", "Pizza", "Polish", "Pop-Up Restaurants", "Portuguese", "Poutineries", "Russian", "Salad", "Sandwiches", "Scandinavian", "Scottish", "Seafood", "Singaporean", "Slovakian", "Soul Food", "Soup", "Southern", "Spanish", "Sri Lankan", "Steakhouses", "Supper Clubs", "Sushi Bars", "Syrian", "Taiwanese", "Tapas Bars", "Tapas/Small Plates", "Tex-Mex", "Thai", "Turkish", "Ukranian", "Uzbek", "Vegan", "Vegetarian", "Vietnamese", "Waffles", "Wraps"]
    
    
    override func viewWillAppear(_ animated: Bool) {
       
        
        if !radiusCoreData.checkIfCoreDataIsEmpty()
        {
            self.sliderValue = radiusCoreData.loadRadius()
        }
        self.doneButton.isHidden = true
       
        self.distanceSlider.maximumValue = 50
        self.distanceSlider.minimumValue = 1
        self.distanceSlider.setValue(Float(self.sliderValue), animated: false)
        self.distanceLabel.text = String(self.sliderValue) + (self.sliderValue <= 1 ? " mile" : " miles")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        self.cityStateLabel.text = self.cityState
       
        
        // Do any additional setup after loading the view.
        
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
    
    public func getIndexOfSelectedCell() -> Int{
        return self.indexOfSelectedCell
    }
    
    
    
    @IBAction func sliderChangedValue(_ sender: Any) {
        self.doneButton.isHidden = false
        let roundedValue = round((sender as! UISlider).value / step) * step
        (sender as! UISlider).value = roundedValue
        self.sliderValue = Int(roundedValue)
        self.distanceLabel.text = String(Int(roundf(roundedValue))) + ((Int(roundf(roundedValue))) <= 0 ? " mile" : " miles")
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
                tileViewController.setGenre(genre: self.arrayOfGenres[self.indexOfSelectedCell])
            }
            self.radiusCoreData.saveRadius(distance: self.sliderValue)
            tileViewController.setDistance(distance:self.sliderValue)
            tileViewController.setIndexOfSelectedGenre(index: self.indexOfSelectedCell)
        }
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
        self.doneButton.isHidden = false
        
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
