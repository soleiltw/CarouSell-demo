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
    
    func setLeftButton() {
        let leftButton = UIButton(frame: CGRectMake(0, 0, 30, 30))
        leftButton.setBackgroundImage(UIImage(named: "key"), forState: .Normal)
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
        
        collectionView.dataSource = self.headerDataSource
        collectionView.delegate = self.headerDataSource
        collectionView.reloadData()
        
        
        return header
    }
    
    func collectionView(collectionView:
        UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, referenceSizeForHeaderInSection
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
            imageView.image = coverImages[indexPath.row]
        }

        
        return cell
    }
}

protocol GeneralDataSource : UICollectionViewDelegate, UICollectionViewDataSource {
}

class HeaderTableDataSourceDelegate: NSObject, GeneralDataSource {
    
    let headerImages = [UIImage(named:"Shopping1"), UIImage(named:"Shopping2"), UIImage(named:"Shopping3")]
    
    private let reuseIdentifier = "HeaderImageCollectionCell"
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headerImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        if let imageView = cell.viewWithTag(1) as? UIImageView {
            imageView.image = headerImages[indexPath.row]
        }
        if let actionButton = cell.viewWithTag(2) as? UIButton {
            actionButton.setTitle("Browse more", forState: .Normal)
            actionButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        }
        
        cell.contentView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        return cell
    }
    
}

