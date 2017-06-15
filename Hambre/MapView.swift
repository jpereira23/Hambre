//
//  MapView.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/13/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit
import GoogleMaps

class MapView: UIView {

    
    private let nibName = "MapView"
    private var view: UIView!
    
    private var latitude : Double! = 56.36
    private var longitude : Double! = -32.48
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
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
        let camera = GMSCameraPosition.camera(withLatitude: round((100*self.latitude)/100), longitude: ((100*self.longitude)/100), zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: 352, height: 248), camera: camera)
        self.view = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: round((100*self.latitude)/100), longitude:((100*self.longitude)/100))
        marker.title = "Africa"
        marker.snippet = "Somewhere in africa"
        marker.map = mapView
        
        addSubview(view)
    }
    
    
    public func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    public func setLatitude(latitude: Double)
    {
        self.latitude = latitude
    }
    
    public func setLongitude(longitude: Double)
    {
        self.longitude = longitude
    }
    
}
