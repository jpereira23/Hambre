//
//  Negocio.swift
//  Hambre
//
//  Created by Jeffery Pereira on 5/29/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class Negocio: NSObject {
    private let businessName : String!
    private let businessImageUrl : URL?
    
    public init(businessName: String, businessImageUrl: URL)
    {
        self.businessName = businessName
        self.businessImageUrl = businessImageUrl
        
    }

    public func getBusinessImage() -> URL?
    {
        return self.businessImageUrl!
    }
    
    public func getBusinessName() -> String
    {
        return self.businessName
    }
}
