//
//  ViewController.swift
//  CarouSell-demo
//
//  Created by Brian Hu on 4/7/16.
//  Copyright © 2016 Brian Hu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    private let reuseIdentifier = "ContentImageCollectionCell"
    @IBOutlet weak var contentLayout: UICollectionViewFlowLayout!
    
    var searchController : UISearchController!
    
    var headerDataSource : GeneralDataSource?
    
    
    let coverImages = [UIImage(named:"Shopping1"), UIImage(named:"Shopping2"), UIImage(named:"Shopping3"), UIImage(named:"Shopping1"), UIImage(named:"Shopping2"), UIImage(named:"Shopping3"), UIImage(named:"Shopping1"), UIImage(named:"Shopping2"), UIImage(named:"Shopping3"), UIImage(named:"Shopping1"), UIImage(named:"Shopping2"), UIImage(named:"Shopping3"), UIImage(named:"Shopping1"), UIImage(named:"Shopping2"), UIImage(named:"Shopping3")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationController?.navigationBar.barStyle = .Black
        
        self.searchController = UISearchController(searchResultsController:  nil)
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        
        self.navigationItem.titleView = searchController.searchBar
        
        self.definesPresentationContext = true
        
        self.setLeftButton()

        let spacingWidth = Float(10)
        let width = (Float(UIScreen.mainScreen().bounds.width) - spacingWidth * Float(2 + 1)) / 2
        self.contentLayout.itemSize = CGSize(width: CGFloat(width), height: CGFloat(width))
        
        self.headerDataSource = HeaderTableDataSourceDelegate()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func setLeftButton() {
        let leftButton = UIButton(frame: CGRectMake(0, 0, 30, 30))
        leftButton.setBackgroundImage(UIImage(named: "key")?.imageWithColor(UIColor.whiteColor()), forState: .Normal)
        leftButton.adjustsImageWhenHighlighted = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.setLeftButton()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath)
        header.backgroundColor = UIColor.whiteColor()
        
        let collectionView = header.viewWithTag(1) as! UICollectionView
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: 220)
        
        let headerDataSource = self.headerDataSource as! HeaderTableDataSourceDelegate
        headerDataSource.collectionView = collectionView
        
        
        collectionView.dataSource = self.headerDataSource
        collectionView.delegate = self.headerDataSource
        collectionView.reloadData()
        
        headerDataSource.setup()
        
        if let pageControl = header.viewWithTag(2) as? UIPageControl {
            headerDataSource.pageControl = pageControl
            
            pageControl.numberOfPages = headerDataSource.headerImages.count
            pageControl.addTarget(self.headerDataSource, action: #selector(HeaderTableDataSourceDelegate.pageChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        }
        
        
        return header
    }
    
    func collectionView(collectionView:UICollectionView, layout collectionViewLayout:UICollectionViewLayout, referenceSizeForHeaderInSection
        section: Int) -> CGSize {
        
        return CGSize(width: UIScreen.mainScreen().bounds.width, height: 220)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coverImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        if let imageView = cell.viewWithTag(1) as? UIImageView {
            imageView.image = coverImages[indexPath.item]
        }
        
        cell.contentView.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.contentView.layer.borderWidth = 1
        
        return cell
    }
    

}

protocol GeneralDataSource : UICollectionViewDelegate, UICollectionViewDataSource {
}

class HeaderTableDataSourceDelegate: NSObject, GeneralDataSource {
    
    let headerImages = [UIImage(named:"Shopping1"), UIImage(named:"Shopping2"), UIImage(named:"Shopping3")]
    
    private let reuseIdentifier = "HeaderImageCollectionCell"
    
    var collectionView : UICollectionView?
    var pageControl : UIPageControl?
    
    var timer : NSTimer?
    
    /**
        Setup before using this datasource.
     */
    func setup() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(HeaderTableDataSourceDelegate.counterTimer(_:)), userInfo: nil, repeats: true)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headerImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        if let imageView = cell.viewWithTag(1) as? UIImageView {
            imageView.image = headerImages[indexPath.item]
        }
        if let actionButton = cell.viewWithTag(2) as? UIButton {
            actionButton.setTitle("Browse more", forState: .Normal)
            actionButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        }
        
        return cell
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        let pageNum = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.pageControl!.currentPage = Int(pageNum)
    }
    
    // MARK: - Private
    
    /**
     We be called when user select dot form page control.
    
     - Parameters
        - sender: Could be any
     */
    func pageChanged(sender:AnyObject) {
        let pageControl = sender as? UIPageControl
        let x = CGFloat(pageControl!.currentPage) * self.collectionView!.frame.size.width
        self.collectionView!.setContentOffset(CGPointMake(x, 0), animated: true)

    }
    
    /**
     A counter timer for automatic scroll our header collection view.
     
     - Parameters
        - sender: The trigger object, could be any.
     */
    func counterTimer(sender:AnyObject) {
        let nextIndex = self.pageControl!.currentPage + 1 < self.headerImages.count ? self.pageControl!.currentPage + 1 : 0
        
        self.pageControl!.currentPage = nextIndex
        
        let x = CGFloat(nextIndex) * self.collectionView!.frame.size.width
        self.collectionView!.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
}

