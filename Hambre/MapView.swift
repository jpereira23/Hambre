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

    
    @IBOutlet var directionsButton: UIButton!
    private let nibName = "MapView"
    private var view: UIView!
    
    private var latitude : Double! = 56.36
    private var longitude : Double! = -32.48
    private var restaurant = "Restaurant"
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    public func setRestaurantTitle(restaurant: String)
    {
        self.restaurant = restaurant
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
        print("latitude: \(self.latitude), longitude: \(self.longitude)")
        
        let camera = GMSCameraPosition.camera(withLatitude: self.latitude, longitude: self.longitude, zoom: 16)
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: 325, height: 199
        ), camera: camera)
        self.view.addSubview(mapView)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.latitude, longitude:self.longitude)
        marker.title = self.restaurant
        marker.snippet = "Selected Restaurant"
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
