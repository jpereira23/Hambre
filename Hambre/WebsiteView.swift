//
//  WebsiteView.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/14/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class WebsiteView: UIView {

    
    @IBOutlet var aWebView: UIWebView!
    private var website : String = "https://google.com"
    private var view: WebsiteView!
    private var nibName = "WebsiteView"
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
        
    public func setWebsiteUrl(website: String)
    {
        self.website = website
    }
    
    public func getView() -> UIView
    {
        return self.view
    }
    
    func xibSetUp()
    {
        self.view = loadViewFromNib() as! WebsiteView
        self.view.frame = self.bounds
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.view.setWebsiteUrl(website: self.website)
        addSubview(self.view)
    }
    
    public func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    override func didMoveToWindow()
    {
        print("We In this window")
        self.aWebView.loadRequest(URLRequest(url: URL(string: self.website)! as URL) as URLRequest)
    }
    
}
