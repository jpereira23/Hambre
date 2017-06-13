//
//  ReviewView.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/12/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class ReviewView: UIView {
    @IBOutlet var tableView: UITableView!

    private var arrayOfReviews = [Review]()
    private var nibName = "ReviewView"
    private var view: UIView!
    private var url : String!
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    public func setArrayOfReviews(reviews: [Review])
    {
        self.arrayOfReviews = reviews
    }
    
    public func setUrl(url: String)
    {
        self.url = url
    }
    
    public func getUrl() -> String
    {
        return self.url
    }
    
    public func getView() -> UIView
    {
        return self.view
    }
    
    func xibSetUp()
    {
        self.view = loadViewFromNib()
        self.view.frame = self.bounds
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(self.view)
    }
    
    public func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    public func getCountOfArray() -> Int
    {
        return self.arrayOfReviews.count
    }
    
    public func filterArray(anId: String) -> [Review]
    {
        var reviews = [Review]()
        for review in self.arrayOfReviews
        {
            let theId = review.getId()
            if theId == anId
            {
                reviews.append(review)
            }
        }
        return reviews
    }
    
}

extension ReviewView : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ReviewTableViewCell
        let array = self.filterArray(anId: self.getUrl())
        
        cell.nameField.text = array[indexPath.row].getReviewer()
        cell.commentField.text = array[indexPath.row].getSummaryReview()
        cell.reviewField.text = String(array[indexPath.row].getReview())
        
        return cell
    }
}

extension ReviewView : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getCountOfArray()
    }
}
