//
//  ViewController.swift
//  CarouSell-demo
//
//  Created by Brian Hu on 4/7/16.
//  Copyright © 2016 Brian Hu. All rights reserved.
//

import UIKit
import SDWebImage
import GestureRecognizerClosures

class ViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    private let reuseIdentifier = "ImageProgressCollectionCell"
    @IBOutlet weak var contentLayout: UICollectionViewFlowLayout!
    
    var searchController : UISearchController!
    
    var headerDataSource : GeneralDataSource?
    
    
    let coverImages = [
        [CategoryImageConstants.title:"Cloth",CategoryImageConstants.imageURL:"http://i.istockimg.com/image-zoom/68380373/3/380/253/stock-photo-68380373-mannequins-in-fashion-shop-display-window.jpg"],
        [CategoryImageConstants.title:"Men Cloth",CategoryImageConstants.imageURL:"http://i.istockimg.com/image-zoom/24357274/3/380/254/stock-photo-24357274-clothing-store-window.jpg"],
        [CategoryImageConstants.title:"Mall",CategoryImageConstants.imageURL:"http://i.istockimg.com/image-zoom/61355814/3/380/253/stock-photo-61355814-modern-shopping-mall-with-outdoor-seating.jpg"],
        [CategoryImageConstants.title:"Pay",CategoryImageConstants.imageURL:"http://i.istockimg.com/image-zoom/85516551/3/380/254/stock-photo-85516551-couple-looking-at-their-shopping-bags.jpg"],
        [CategoryImageConstants.title:"Whole View",CategoryImageConstants.imageURL:"http://i.istockimg.com/image-zoom/86475293/3/380/253/stock-photo-86475293-haneda-airport.jpg"],
        [CategoryImageConstants.title:"Discount", CategoryImageConstants.imageURL:"http://i.istockimg.com/image-zoom/84319517/3/380/254/stock-photo-84319517-sale.jpg"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "CarouSell"
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        // preferredStatusBarStyle isn't called http://stackoverflow.com/questions/19022210/preferredstatusbarstyle-isnt-called/19513714#19513714
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowCategoryDetail" {
            
        }
    }
    
    // MARK: - UISearchControllerDelegate
    
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
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageProgressTitleCell
        
        let dataObject : Dictionary<String, String> = self.coverImages[indexPath.item]
        
        // Image download
        cell.progressView.hidden = false
        
        let manager:SDWebImageManager = SDWebImageManager.sharedManager()
        manager.downloadImageWithURL(NSURL(string:dataObject[CategoryImageConstants.imageURL]!), options: SDWebImageOptions.RefreshCached, progress: { (receivedSize:Int, expectedSize:Int) in
            
            cell.progressView.setProgress(Float(receivedSize) / Float(expectedSize), animated: true)
            
            }, completed: { (image:UIImage!, error:NSError!, cacheType:SDImageCacheType, finished:Bool, url: NSURL!) in
                
                cell.progressView.hidden = true
                
                if image != nil {
                    cell.imageView.image = image
                }
        })
        
        cell.titleLabel.text = dataObject[CategoryImageConstants.title]
        
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
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! HeaderImageButtonCell
        
        let currentImage = headerImages[indexPath.item]
        
        cell.imageView.image = currentImage
        cell.actionButton.setTitle("Browse more", forState: .Normal)
        cell.actionButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        // Method 1. Add target action
        //        cell.actionButton.addTarget(self, action: #selector(handledActionButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        // Adding addtional potision value
        cell.actionButton.tag = indexPath.item
        
        // Method 2. Use GestureRecognizerClosures
        cell.actionButton.onTap { (tapGestureRecognizer) in
            print("Pressed GestureRecognizerClosures at \(indexPath.item as Int)!")
        }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageNum = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.pageControl!.currentPage = Int(pageNum)
    }
    
    func handledActionButton(sender:AnyObject?) {
        let currentButton = sender as! UIButton
        print("Pressed at \(currentButton.tag as Int)!")
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

