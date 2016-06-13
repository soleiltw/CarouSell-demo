//
//  RegistrationViewController.swift
//  CarouSell-demo
//
//  Created by Brian Hu on 4/7/16.
//  Copyright © 2016 Brian Hu. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UIScrollViewDelegate {
    
    private let pageCellReuseIdentifier = "pageCellReuseIdentifier"
    
    @IBOutlet weak var tutorialCollectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var loginWithEmailButton: UIButton!
    let pages = [[Constants.image: "coffee", Constants.title: "drink a coffee", Constants.description: "i like coffee "], [Constants.image: "airplan", Constants.title: "take a flight", Constants.description: "i like to take a flight"], [Constants.image: "dessert", Constants.title: "see sunset in the dessert", Constants.description: "i like seeing sunset in the dessert"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tutorialCollectionView.registerNib(UINib(nibName: "PageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: pageCellReuseIdentifier)

        self.layout.itemSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: 382)
        
        self.pageControl.numberOfPages = self.pages.count
        
        self.setUpLoginWithEmailButton()
    }
    
    private func setUpLoginWithEmailButton() {
        self.loginWithEmailButton.layer.cornerRadius = 5
        
        let buttonTitle = NSMutableAttributedString(string: "Sign up or Log in with ")
        let boldEmail = NSAttributedString(string: "Email", attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0)])
        buttonTitle.appendAttributedString(boldEmail)
        self.loginWithEmailButton.setAttributedTitle(buttonTitle, forState: .Normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Collecton View data source
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @IBAction func pageChanged(sender: AnyObject) {
        let x = CGFloat(pageControl.currentPage) * self.tutorialCollectionView.frame.size.width
        self.tutorialCollectionView.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageNum = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.pageControl.currentPage = Int(pageNum)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(pageCellReuseIdentifier, forIndexPath: indexPath) as! PageCollectionViewCell
        
        let page = pages[indexPath.item]
        cell.pageImageView.image = UIImage(named: page[Constants.image]!)
        cell.titleLabel.text = page[Constants.title]
        cell.descriptionLabel.text = page[Constants.description]

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
