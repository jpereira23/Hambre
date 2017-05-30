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
    private let businessImageUrl : URL!
    
    public init(businessName: String, businessImageUrl: URL)
    {
        self.businessName = businessName
        self.businessImageUrl = businessImageUrl
    }
    
    public func getBusinessImage() -> UIImage
    {
        return self.downloadContents() 
    }
    
    private func downloadContents() -> UIImage
    {
        let session = URLSession(configuration: .default)
        var anImage = UIImage()
        _ = session.dataTask(with: self.businessImageUrl) { (data, response, error) in
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                if let res = response as? HTTPURLResponse {
                    print("Downloaded picture with response code \(res.statusCode)")
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        anImage = image!
                    }
                    else
                    {
                        print("Couldnt get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
    
            }
        }
        return anImage
    
    }
    
    public func getBusinessName() -> String
    {
        return self.businessName
    }
}
