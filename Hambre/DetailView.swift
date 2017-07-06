//
//  DetailView.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/8/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class DetailView: UIView {
    
    /*
    @IBOutlet var addressField: UILabel!
    @IBOutlet var phoneField: UILabel!
    @IBOutlet var isClosedField: UILabel!
    @IBOutlet var websiteUrlField: UILabel!
    */
    
    @IBOutlet weak var websiteUrlField: UIButton!
    
    @IBOutlet weak var addressField: UIButton!
    
    @IBOutlet weak var phoneFIeld: UIButton!
 
    @IBOutlet weak var isClosedField: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    
    private var address : String! = "Not an address"
    private var phoneNumber : String! = "Phone Number: (000) 000-0000"
    private var isClosed : String! = "Closed"
    private var websiteUrl : String! = "http://google.com"
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
        self.addressField.setTitle(self.address, for: .normal)
        self.phoneFIeld.setTitle(self.phoneNumber, for: .normal)
        self.isClosedField.setTitle(self.isClosed, for: .normal)
        self.websiteUrlField.setTitle("View Website", for: .normal)
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
    
    public func setPhoneField(phone: String)
    {
        self.phoneNumber = phone
    }
    
    public func setWebsiteUrl(url: String)
    {
        self.websiteUrl = url
    }
    
    public func setIsClosed(isClosed: Bool)
    {
        if isClosed
        {
            self.isClosed = "Currently closed."
        }
        else
        {
            self.isClosed = "Currently open."
        }
    }

}
