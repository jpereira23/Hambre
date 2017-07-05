//
//  DraggableView.swift
//  Hambre
//
//  Created by Jeffery Pereira on 7/4/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

protocol DraggableViewDelegate: NSObjectProtocol {
    func cardSwipedLeft(_ card: UIView)
    
    func cardSwipedRight(_ card: UIView)
}
let ACTION_MARGIN = 120
let SCALE_STRENGTH = 4
let SCALE_MAX = 0.93
let ROTATION_MAX = 1
let ROTATION_STRENGTH = 320
let ROTATION_ANGLE = Double.pi/8.0

class DraggableView: UIView {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var businessNameField: UILabel!
    @IBOutlet var milesField: UILabel!
    @IBOutlet var reviewsField: UILabel!
    
    weak var delegate: DraggableViewDelegate?
    var panGestureRecognizer: UIPanGestureRecognizer?
    var originalPoint = CGPoint.zero
    var overlayView: OverlayView?
    private var businessName = "Business"
    private var imageUrl :URL? = nil
    private var miles = "0 miles"
    private var reviews = "0 reviews"
    private var xFromCenter: CGFloat = 0.0
    private var yFromCenter: CGFloat = 0.0
    
    private var view: UIView!
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect)
    {
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
        self.businessNameField.text = self.businessName
        self.milesField.text = self.miles
        self.reviewsField.text = self.reviews
        if self.imageUrl != nil
        {
            self.imageView.setImageWith(self.imageUrl!)
            self.imageView.contentMode = UIViewContentMode.scaleAspectFit
        }
        // Need else statement for businesses that dont have url
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged))
        addGestureRecognizer(panGestureRecognizer!)
        overlayView = OverlayView(frame: CGRect(x: CGFloat(self.frame.size.width / 2 - 100), y: CGFloat(0), width: CGFloat(100), height: CGFloat(100)))
        overlayView?.alpha = 0
        view.addSubview(overlayView!)
        addSubview(view)
        
    }
    
    public func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DraggableView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    public func setBusinessName(name: String)
    {
        self.businessName = name
    }
    
    public func setMiles(miles: String)
    {
        self.miles = miles
    }
    
    public func setReviews(reviews: String)
    {
        self.reviews = reviews
    }
    
    public func setImageUrl(url: URL)
    {
        self.imageUrl = url
    }
    
    public func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer)
    {
        xFromCenter = gestureRecognizer.translation(in: self).x

        yFromCenter = gestureRecognizer.translation(in: self).y
        
        
        switch gestureRecognizer.state {
        
        case .began:
            originalPoint = center
        
        case .changed:
            let rotationStrength: CGFloat = min(xFromCenter / CGFloat(ROTATION_STRENGTH), CGFloat(ROTATION_MAX))
            let rotationAngel: CGFloat = (CGFloat)(CGFloat(ROTATION_ANGLE) * rotationStrength)
            let scale: CGFloat = max(1 - fabs(CGFloat(rotationStrength)) / CGFloat(SCALE_STRENGTH), CGFloat(SCALE_MAX))
            center = CGPoint(x: CGFloat(originalPoint.x + xFromCenter), y: CGFloat(originalPoint.y + yFromCenter))
            let transform = CGAffineTransform(rotationAngle: rotationAngel)
            let scaleTransform: CGAffineTransform = transform.scaledBy(x: scale, y: scale)
            self.transform = scaleTransform
            updateOverlay(xFromCenter)
        case .ended:
            afterSwipeAction()
        case .possible:
            break
        case .cancelled:
            break
        case .failed:
            break
        }
    }
    
    func updateOverlay(_ distance: CGFloat) {
        if distance > 0 {
            overlayView?.mode = .GGOverlayViewModeRight
        }
        else {
            overlayView?.mode = .GGOverlayViewModeLeft
        }
        overlayView?.alpha = CGFloat(min(fabsf(Float(distance)) / 100, Float(0.4)))
    }
    
    func afterSwipeAction() {
        if xFromCenter > CGFloat(ACTION_MARGIN) {
            rightAction()
        }
        else if xFromCenter < CGFloat(-ACTION_MARGIN) {
            leftAction()
        }
        else {
            //%%% resets the card
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.center = self.originalPoint
                self.transform = CGAffineTransform(rotationAngle: 0)
                self.overlayView?.alpha = 0
            })
        }
        
    }
    
    func rightAction() {
        let finishPoint = CGPoint(x: CGFloat(500), y: CGFloat(2 * yFromCenter + originalPoint.y))
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.center = finishPoint
        }, completion: {(_ complete: Bool) -> Void in
            self.removeFromSuperview()
        })
        delegate?.cardSwipedRight(self)
    }
    
    func leftAction() {
        let finishPoint = CGPoint(x: CGFloat(-500), y: CGFloat(2 * yFromCenter + originalPoint.y))
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.center = finishPoint
        }, completion: {(_ complete: Bool) -> Void in
            self.removeFromSuperview()
        })
        delegate?.cardSwipedLeft(self)
    }
    
    func rightClickAction() {
        let finishPoint = CGPoint(x: CGFloat(600), y: CGFloat(center.y))
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.center = finishPoint
            self.transform = CGAffineTransform(rotationAngle: 1)
        }, completion: {(_ complete: Bool) -> Void in
            self.removeFromSuperview()
        })
        delegate?.cardSwipedRight(self)
        print("YES")
    }
    
    func leftClickAction() {
        let finishPoint = CGPoint(x: CGFloat(-600), y: CGFloat(center.y))
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.center = finishPoint
            self.transform = CGAffineTransform(rotationAngle: -1)
        }, completion: {(_ complete: Bool) -> Void in
            self.removeFromSuperview()
        })
        delegate?.cardSwipedLeft(self)
        print("NO")
    }
    
    
}
