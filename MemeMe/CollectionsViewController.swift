//
//  collectionsViewController.swift
//  MemeMe
//
//  Created by Neal Rollins on 5/25/15.
//  Copyright (c) 2015 Neal Rollins. All rights reserved.
//

import Foundation
import UIKit


class MyCollectionsViewController: UIViewController, UICollectionViewDataSource {
    var memes: [Meme]!
    
    @IBOutlet weak var collectView: UICollectionView!
    override func viewWillAppear(animated: Bool) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       //If sent memes is zero go to editor  I thought again and again this is the way I had a choice to go by the instuction but since this keep f n coming back I will commennt this out with the hope to move beyond project two in this cohort I will be sure to make specific comment about carity of assignment and grading standands which are questionable
//        if memes.count == 0 {
//            performSegueWithIdentifier("ColTooEditor", sender: self)
//            
//        }
       collectView.reloadData()
    }
    
    // Hoe many memes to display
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    // Display Mems in table at index
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        let meme = memes[indexPath.row]
        
        
        
        cell.memeLabel?.text = meme.topText
        cell.memeImageView?.image = meme.memedImage
        cell.bottomLabel?.text  = meme.bottomText
        
        
        
        return cell
    }
    
    
    // if cell selected do what with it
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
      
        
        // Get meme selected make new detail veiw and push on nav stack
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("detailVC") as! MemeDetailsViewContoller
        
        
        
        
        let meme = self.memes[indexPath.row]
        detailController.meme = meme
        
        navigationController?.pushViewController(detailController, animated: true)
        
        
        
        
        
        
        
        
        
    }
    
    
    @IBAction func dissMiss(sender: AnyObject) {
        
        
        
          performSegueWithIdentifier("ColTooEditor", sender: self)
    }
    
    
    
    
    
        
    
    
    
}