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
    private var averageOfReviews: Float = 0.0
    private var url : String!
   
    @IBOutlet var reviewStarOne: UIImageView!
    @IBOutlet var reviewStarTwo: UIImageView!
    @IBOutlet var reviewStarThree: UIImageView!
    @IBOutlet var reviewStarFour: UIImageView!
    @IBOutlet var reviewStarFive: UIImageView!
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    
    init(frame: CGRect, averageOfReviews: Float)
    {
        super.init(frame: frame)
        self.averageOfReviews = averageOfReviews
    }
    
    public func setArrayOfReviews(reviews: [Review])
    {
        
        self.arrayOfReviews.removeAll()
        self.arrayOfReviews = reviews
        if self.tableView != nil
        {
            self.tableView.reloadData()
        }
    }
    
    public func setUrl(url: String)
    {
        self.url = url
    }
    
    public func setAverageReviews(averageReviews: Float)
    {
        self.averageOfReviews = averageReviews
    }
    
    public func getUrl() -> String
    {
        return self.url
    }
    
    public func getView() -> UIView
    {
        return self.view
    }
    
    override func didMoveToSuperview() {
        print("MOVED TO SUPERVIEW")
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
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
        self.view.averageOfReviews = self.averageOfReviews
        self.view.setReviewLinup()
        addSubview(self.view)
        print(self.averageOfReviews)
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
    
    public func setReviewLinup()
    {
        if self.averageOfReviews == 0.0
        {
            self.reviewStarOne.image = UIImage(named: "graystar")
            self.reviewStarTwo.image = UIImage(named: "graystar")
            self.reviewStarThree.image = UIImage(named: "graystar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if self.averageOfReviews > 0.0 && self.averageOfReviews <= 0.5
        {
            self.reviewStarOne.image = UIImage(named: "halfstar")
            self.reviewStarTwo.image = UIImage(named: "graystar")
            self.reviewStarThree.image = UIImage(named: "graystar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if self.averageOfReviews > 0.5 && self.averageOfReviews <= 1.0
        {
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "graystar")
            self.reviewStarThree.image = UIImage(named: "graystar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if self.averageOfReviews > 0.5 && self.averageOfReviews <= 1.5
        {
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "halfstar")
            self.reviewStarThree.image = UIImage(named: "graystar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if self.averageOfReviews > 1.5 && self.averageOfReviews <= 2.0
        {
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "graystar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if self.averageOfReviews > 2.0 && self.averageOfReviews <= 2.5
        {
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "halfstar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if self.averageOfReviews > 2.5 && self.averageOfReviews <= 3.0
        {
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "fullstar")
            self.reviewStarFour.image = UIImage(named: "graystar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if self.averageOfReviews > 3.0 && self.averageOfReviews <= 3.5
        {
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "fullstar")
            self.reviewStarFour.image = UIImage(named: "halfstar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if self.averageOfReviews > 3.5 && self.averageOfReviews <= 4.0
        {
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "fullstar")
            self.reviewStarFour.image = UIImage(named: "fullstar")
            self.reviewStarFive.image = UIImage(named: "graystar")
        }
        else if self.averageOfReviews > 4.0 && self.averageOfReviews <= 4.5
        {
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "fullstar")
            self.reviewStarFour.image = UIImage(named: "fullstar")
            self.reviewStarFive.image = UIImage(named: "halfstar")
        }
        else if self.averageOfReviews > 4.5 && self.averageOfReviews <= 5.0
        {
            self.reviewStarOne.image = UIImage(named: "fullstar")
            self.reviewStarTwo.image = UIImage(named: "fullstar")
            self.reviewStarThree.image = UIImage(named: "fullstar")
            self.reviewStarFour.image = UIImage(named: "fullstar")
            self.reviewStarFive.image = UIImage(named: "fullstar")
        }
       
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
            
            cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ReviewTableViewCell
        }
        
        
        let array = self.filterArray(anId: self.getUrl())
        cell?.nameField.text = array[indexPath.row].getReviewer()
        cell?.commentField.text = array[indexPath.row].getSummaryReview()
        cell?.dateCreatedField.text = array[indexPath.row].getCreationDate()
        cell?.setStars(averageOfReviews: Float(array[indexPath.row].getReview()))
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        let array = self.filterArray(anId: self.getUrl())
        let comment = array[indexPath.row].getSummaryReview()
        let countOfComment = comment.characters.count
        print("count of this comment \(countOfComment)")
    
        
        return 95
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterArray(anId: self.getUrl()).count
    }
}
