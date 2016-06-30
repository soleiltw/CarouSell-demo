//
//  CategorySellsViewController.swift
//  CarouSell-demo
//
//  Created by Edward Chiang on 6/30/16.
//  Copyright © 2016 Brian Hu. All rights reserved.
//

import UIKit
import GestureRecognizerClosures
import Social
import FBSDKShareKit

private let reuseIdentifier = "ContentImageCollectionCell"

class CategorySellsViewController: UICollectionViewController {
    
    @IBOutlet weak var contentLayout: UICollectionViewFlowLayout!
    
    let coverImages = [UIImage(named:"Shopping1"), UIImage(named:"Shopping2"), UIImage(named:"Shopping3"), UIImage(named:"Shopping1"), UIImage(named:"Shopping2"), UIImage(named:"Shopping3"), UIImage(named:"Shopping1"), UIImage(named:"Shopping2"), UIImage(named:"Shopping3"), UIImage(named:"Shopping1"), UIImage(named:"Shopping2"), UIImage(named:"Shopping3"), UIImage(named:"Shopping1"), UIImage(named:"Shopping2"), UIImage(named:"Shopping3")]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spacingWidth = Float(10)
        let width = (Float(UIScreen.mainScreen().bounds.width) - spacingWidth * Float(2 + 1)) / 2
        self.contentLayout.itemSize = CGSize(width: CGFloat(width), height: CGFloat(width))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.coverImages.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        
        let dataObject = self.coverImages[indexPath.item]
    
        // Configure the cell
        if let imageView = cell.viewWithTag(1) as? UIImageView {
            imageView.image = dataObject
        }
        
        if let button = cell.viewWithTag(2) as? UIButton {
            button.onTap({ (tapGestureRecognizer) in
                let actionSheet = UIAlertController(title: "Social Share", message: "Share with your friends", preferredStyle: .ActionSheet)
                
                // Twitter Share
                actionSheet.addAction(UIAlertAction(title: "Share on Twitter (Social)", style: .Default, handler: { (alertAction) in
                    
                    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                        
                        let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                        twitterComposeVC.setInitialText("How do you thing? your_URL")
                        
                        self.presentViewController(twitterComposeVC, animated: true, completion: nil)
                        
                    } else {
                        self.showAlertMessage("You are not logged into your Twitter account.")
                    }
                    
                }))
                
                // Facebook Share
                actionSheet.addAction(UIAlertAction(title: "Share on Facebook (Social)", style: .Default, handler: { (alertAction) in
                    
                    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                        
                        let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                        twitterComposeVC.setInitialText("How do you think? your_URL")
                        
                        self.presentViewController(twitterComposeVC, animated: true, completion: nil)
                        
                    } else {
                        self.showAlertMessage("You are not logged into your Facebook account.")
                    }
                    
                }))
                
                actionSheet.addAction(UIAlertAction(title: "Facebook Share", style: .Default, handler: { (alertAction) in
                    
                    let photo = FBSDKSharePhoto()
                    photo.image = dataObject
                    photo.caption = "How do you think?"
                    photo.userGenerated = true
                    
                    let content = FBSDKSharePhotoContent()
                    content.photos = [photo]
                    
                    FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: nil)
                }))
                
                actionSheet.addAction(UIAlertAction(title: "Facebook Message", style: .Default, handler: { (alertAction) in
                    
                    let photo = FBSDKSharePhoto()
                    photo.image = dataObject
                    photo.caption = "How do you think?"
                    photo.userGenerated = true
                    
                    let content = FBSDKSharePhotoContent()
                    content.photos = [photo]
                    
                    FBSDKMessageDialog.showWithContent(content, delegate: nil)
                }))
                
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
                
                self.presentViewController(actionSheet, animated: true, completion: nil)
            })
        }
        
        cell.contentView.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.contentView.layer.borderWidth = 1
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: "Notice", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }

}
