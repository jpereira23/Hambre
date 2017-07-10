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
let ROTATION_STRENGTH = 360
let ROTATION_ANGLE = Double.pi/8.0

class DraggableView: UIView {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var businessNameField: UILabel!
    @IBOutlet var milesField: UILabel!
    @IBOutlet var reviewsField: UILabel!
    @IBOutlet var starImageOne: UIImageView!
    @IBOutlet var starImageTwo: UIImageView!
    @IBOutlet var starImageThree: UIImageView!
    @IBOutlet var starImageFour: UIImageView!
    @IBOutlet var starImageFive: UIImageView!
    
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
    private var floatForStar : Float!
    private var theBusiness : PersonalBusiness? = nil
    private var view: UIView!
    private var milesEnabled = true
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    
    init(frame: CGRect, floatForStar: Float)
    {
        super.init(frame: frame)
        self.floatForStar = floatForStar
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
        if self.miles == "Miles not available"
        {
            self.milesField.font = UIFont(name: self.milesField.font.fontName, size: 8)
        }
        self.milesField.text = self.miles
        self.reviewsField.text = self.reviews
        self.setReviewImages()
        if self.imageUrl != nil
        {
            let data = try? Data(contentsOf: self.imageUrl!)
            if data != nil
            {
                self.imageView.image = UIImage(data: data!)
                self.imageView.contentMode = UIViewContentMode.scaleAspectFill
            }
        }
        // Need else statement for businesses that dont have url
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged))
        view.addGestureRecognizer(panGestureRecognizer!)
        
        overlayView = OverlayView(frame: CGRect(x: CGFloat(self.frame.size.width / 2 - 100), y: CGFloat(0), width: CGFloat(100), height: CGFloat(100)))
        overlayView?.alpha = 0
        addSubview(overlayView!)
        addSubview(view)
        
    }
    
    public func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DraggableView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    public func setReviewImages()
    {
        if self.floatForStar == 0.0
        {
            self.starImageOne.image = UIImage(named: "graystar")
            self.starImageTwo.image = UIImage(named: "graystar")
            self.starImageThree.image = UIImage(named: "graystar")
            self.starImageFour.image = UIImage(named: "graystar")
            self.starImageFive.image = UIImage(named: "graystar")
        }
        else if self.floatForStar > 0.0 && self.floatForStar <= 0.5
        {
            self.starImageOne.image = UIImage(named: "halfstar")
            self.starImageTwo.image = UIImage(named: "graystar")
            self.starImageThree.image = UIImage(named: "graystar")
            self.starImageFour.image = UIImage(named: "graystar")
            self.starImageFive.image = UIImage(named: "graystar")
        }
        else if self.floatForStar > 0.5 && self.floatForStar <= 1.0
        {
            self.starImageOne.image = UIImage(named: "fullstar")
            self.starImageTwo.image = UIImage(named: "graystar")
            self.starImageThree.image = UIImage(named: "graystar")
            self.starImageFour.image = UIImage(named: "graystar")
            self.starImageFive.image = UIImage(named: "graystar")
        }
        else if self.floatForStar > 1.0 && self.floatForStar <= 1.5
        {
            self.starImageOne.image = UIImage(named: "fullstar")
            self.starImageTwo.image = UIImage(named: "halfstar")
            self.starImageThree.image = UIImage(named: "graystar")
            self.starImageFour.image = UIImage(named: "graystar")
            self.starImageFive.image = UIImage(named: "graystar")
        }
        else if self.floatForStar > 1.5 && self.floatForStar <= 2.0
        {
            self.starImageOne.image = UIImage(named: "fullstar")
            self.starImageTwo.image = UIImage(named: "fullstar")
            self.starImageThree.image = UIImage(named: "graystar")
            self.starImageFour.image = UIImage(named: "graystar")
            self.starImageFive.image = UIImage(named: "graystar")
        }
        else if self.floatForStar > 2.0 && self.floatForStar <= 2.5
        {
            self.starImageOne.image = UIImage(named: "fullstar")
            self.starImageTwo.image = UIImage(named: "fullstar")
            self.starImageThree.image = UIImage(named: "halfstar")
            self.starImageFour.image = UIImage(named: "graystar")
            self.starImageFive.image = UIImage(named: "graystar")
        }
        else if self.floatForStar > 2.5 && self.floatForStar <= 3.0
        {
            self.starImageOne.image = UIImage(named: "fullstar")
            self.starImageTwo.image = UIImage(named: "fullstar")
            self.starImageThree.image = UIImage(named: "fullstar")
            self.starImageFour.image = UIImage(named: "graystar")
            self.starImageFive.image = UIImage(named: "graystar")
        }
        else if self.floatForStar > 3.0 && self.floatForStar <= 3.5
        {
            self.starImageOne.image = UIImage(named: "fullstar")
            self.starImageTwo.image = UIImage(named: "fullstar")
            self.starImageThree.image = UIImage(named: "fullstar")
            self.starImageFour.image = UIImage(named: "halfstar")
            self.starImageFive.image = UIImage(named: "graystar")
        }
        else if self.floatForStar > 3.5 && self.floatForStar <= 4.0
        {
            self.starImageOne.image = UIImage(named: "fullstar")
            self.starImageTwo.image = UIImage(named: "fullstar")
            self.starImageThree.image = UIImage(named: "fullstar")
            self.starImageFour.image = UIImage(named: "fullstar")
            self.starImageFive.image = UIImage(named: "graystar")
        }
        else if self.floatForStar > 4.0 && self.floatForStar <= 4.5
        {
            self.starImageOne.image = UIImage(named: "fullstar")
            self.starImageTwo.image = UIImage(named: "fullstar")
            self.starImageThree.image = UIImage(named: "fullstar")
            self.starImageFour.image = UIImage(named: "fullstar")
            self.starImageFive.image = UIImage(named: "halfstar")
        }
        else if self.floatForStar > 4.5
        {
            self.starImageOne.image = UIImage(named: "fullstar")
            self.starImageTwo.image = UIImage(named: "fullstar")
            self.starImageThree.image = UIImage(named: "fullstar")
            self.starImageFour.image = UIImage(named: "fullstar")
            self.starImageFive.image = UIImage(named: "fullstar")
        }

    }
    
    public func setBusiness(business: PersonalBusiness)
    {
        self.theBusiness = business
    }
    
    public func getBusiness() -> PersonalBusiness
    {
        return self.theBusiness!
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
        xFromCenter = gestureRecognizer.translation(in: self.view).x

        yFromCenter = gestureRecognizer.translation(in: self.view).y
        
        
        switch gestureRecognizer.state {
        
        case .began:
            originalPoint = self.view.center
        
        case .changed:
            let rotationStrength: CGFloat = min(xFromCenter / CGFloat(ROTATION_STRENGTH), CGFloat(ROTATION_MAX))
            let rotationAngel: CGFloat = (CGFloat)(CGFloat(ROTATION_ANGLE) * rotationStrength)
            let scale: CGFloat = max(1 - fabs(CGFloat(rotationStrength)) / CGFloat(SCALE_STRENGTH), CGFloat(SCALE_MAX))
            self.view.center = CGPoint(x: CGFloat(originalPoint.x + xFromCenter), y: CGFloat(originalPoint.y + yFromCenter))
            let transform = CGAffineTransform(rotationAngle: rotationAngel)
            let scaleTransform: CGAffineTransform = transform.scaledBy(x: scale, y: scale)
            self.view.transform = scaleTransform
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
                self.view.center = self.originalPoint
                self.view.transform = CGAffineTransform(rotationAngle: 0)
                self.overlayView?.alpha = 0
            })
        }
        
    }
    
    func rightAction() {
        let finishPoint = CGPoint(x: CGFloat(1000), y: CGFloat(4 * yFromCenter + originalPoint.y))
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.view.center = finishPoint
        }, completion: {(_ complete: Bool) -> Void in
            self.view.removeFromSuperview()
        })
        print(self.floatForStar)
        delegate?.cardSwipedRight(self)
    }
    
    func leftAction() {
        let finishPoint = CGPoint(x: CGFloat(-500), y: CGFloat(2 * yFromCenter + originalPoint.y))
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.view.center = finishPoint
        }, completion: {(_ complete: Bool) -> Void in
            self.view.removeFromSuperview()
        })
        delegate?.cardSwipedLeft(self)
    }
    
    func rightClickAction() {
        
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.view.transform = CGAffineTransform(scaleX: 11, y: 11)
            //self.transform = CGAffineTransform(translationX: CGFloat(600), y: 0)
            //self.transform = CGAffineTransform(rotationAngle: 1)
            
        }, completion: {(_ complete: Bool) -> Void in
            self.view.removeFromSuperview()
            self.delegate?.cardSwipedRight(self)
        })
        
    }
    
    func leftClickAction() {
        
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.view.transform = CGAffineTransform(scaleX: 11, y: 11)
            //self.transform = CGAffineTransform(translationX: CGFloat(-600), y: 0)
            //self.transform = CGAffineTransform(rotationAngle: -1)
        }, completion: {(_ complete: Bool) -> Void in
            self.view.removeFromSuperview()
            self.delegate?.cardSwipedLeft(self)
        })
        
    }
    
    
}
