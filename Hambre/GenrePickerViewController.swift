//
//  GenrePickerViewController.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/7/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class GenrePickerViewController: UIViewController {

    @IBOutlet var pickerView: UIPickerView!
    var arrayOfGenres = ["all restaurants", "fast food", "mexican", "food", "sandwiches", "burgers", "american", "pizza", "bars", "chinese", "nightlife", "barbeque", "japanese", "breakfast & brunch", "chicken wings", "italian", "afghan" , "asian fusion", "delis", "food trucks", "grocery" , "indian", "filipino", "hot dogs", "text-mex", "thai", "ice cream & frozen yogurt", "salad", "seafood", "sushi bars", "vietnamese", "bubble tea", "diners", "fish & chips", "halal", "hawaiian", "juice bars & smoothies", "korean", "noodles", "soul food", "sports bars", "steakhouses", "bakeries", "buffets", "cafes", "coffee & tea", "event planning & services", "latin american", "pakistani", "specialty food", "wine bars"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let businessTileViewController = segue.destination as! BusinessTileViewController
        businessTileViewController.changeGenre(genre: self.arrayOfGenres[pickerView.selectedRow(inComponent: 0)])
    }

}

extension GenrePickerViewController : UIPickerViewDelegate
{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.arrayOfGenres[row]
    }
}

extension GenrePickerViewController : UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrayOfGenres.count
    }
}
