//
//  RegistrationViewController.swift
//  CarouSell-demo
//
//  Created by Brian Hu on 4/7/16.
//  Copyright © 2016 Brian Hu. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    private let pageCellReuseIdentifier = "pageCellReuseIdentifier"
    
    @IBOutlet weak var tutorialCollectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    let pages = [[Constants.image: "coffee", "title": "drink a coffee", "description": "i like coffee"], ["image": "coffee", "title": "drink a coffee", "description": "i like coffee"], ["image": "coffee", "title": "drink a coffee", "description": "i like coffee"], ["image": "coffee", "title": "drink a coffee", "description": "i like coffee"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tutorialCollectionView.registerNib(UINib(nibName: "PageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: pageCellReuseIdentifier)

        self.layout.itemSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: 382)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Collecton View data source
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(pageCellReuseIdentifier, forIndexPath: indexPath) as! PageCollectionViewCell
        
        let page = pages[indexPath.item]
        cell.pageImageView.image = UIImage(named: page["image"]!)
        cell.titleLabel.text = page["title"]
        cell.descriptionLabel.text = page["description"]

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
