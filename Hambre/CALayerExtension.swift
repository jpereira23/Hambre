//
//  CALayer Extension.swift
//  Hambre
//
//  Created by Waldo on 6/8/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

extension CALayer {
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
}
