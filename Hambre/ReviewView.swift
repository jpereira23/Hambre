//
//  ReviewView.swift
//  Hambre
//
//  Created by Jeffery Pereira on 6/12/17.
//  Copyright © 2017 GOODLIFE. All rights reserved.
//

import UIKit

class ReviewView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var howManyReviews: UILabel!
    @IBOutlet var addReviewButton: UIButton!
    @IBOutlet var tableView: UITableView!
    private var arrayOfReviews = [Review]()
    private var nibName = "ReviewView"
    private var view: ReviewView!
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
        //self.tableView.frame = CGRect(x: 16, y: 25, width: 320, height: 159)
        //self.tableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: "cell")
        //self.tableView.delegate = self
        //self.tableView.dataSource = self
        //self.tableView.reloadData()
        return self.view
    }
    
    override func didMoveToSuperview() {
        print("MOVED TO SUPERVIEW")
    }
    override func didMoveToWindow() {
        self.tableView.register(ReviewTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    
        let numOfReviews = self.filterArray(anId: self.url)
        self.howManyReviews.text! = String(numOfReviews.count) + " Reviews"
        
    }
    
    func xibSetUp()
    {
        self.view = loadViewFromNib() as! ReviewView
        self.view.frame = self.bounds
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.view.setUrl(url: self.url)
        self.view.setArrayOfReviews(reviews: self.arrayOfReviews)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell: ReviewTableViewCell?
        
         let bundle = Bundle(for: type(of: self))
        if let _ = cell{
            cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ReviewTableViewCell
        }
        else
        {
            tableView.register(UINib(nibName: "ReviewTableViewCell", bundle: bundle), forCellReuseIdentifier: "cell")
            
            cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ReviewTableViewCell
        }
        
        
        let array = self.filterArray(anId: self.getUrl())
        cell?.nameField.text = array[indexPath.row].getReviewer()
        cell?.commentField.text = array[indexPath.row].getSummaryReview()
        cell?.reviewField.text = "Review: " + String(array[indexPath.row].getReview())
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 95
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterArray(anId: self.getUrl()).count
    }
}
