//
//  OverlayView.swift
//  Hambre
//
//  Created by Jeffery Pereira on 7/5/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

enum GGOverlayViewMode : Int {
    case GGOverlayViewModeLeft
    case GGOverlayViewModeRight
}
class OverlayView: UIView {

    var mode = GGOverlayViewMode(rawValue: 0)!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMode(_ mode: GGOverlayViewMode) {
        if self.mode == mode {
            return
        }
        self.mode = mode
        if mode == .GGOverlayViewModeLeft {
            //imageView?.image = UIImage(named: "noButton")
        }
        else {
            //imageView?.image = UIImage(named: "yesButton")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //imageView?.frame = CGRect(x: CGFloat(50), y: CGFloat(50), width: CGFloat(100), height: CGFloat(100))
    }
}
