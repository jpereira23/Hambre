//
//  DetailView.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/8/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class DetailView: UIView {

    @IBOutlet var addressField: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    
    private var address : String! = "Not an address"
    private let nibName = "View"
    private var view: UIView!
    
    required init(coder aDecorder: NSCoder) {
        super.init(coder: aDecorder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public func getView() -> UIView
    {
        return self.view
    }
    
    func xibSetUp()
    {
        self.view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.addressField.text = self.address
        addSubview(view)
    }
    
    public func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    public func setAddressField(address: String)
    {
        self.address = address
    }

}
