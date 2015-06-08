//
//  tableViewController.swift
//  MemeMe
//
//  Created by Neal Rollins on 5/25/15.
//  Copyright (c) 2015 Neal Rollins. All rights reserved.
//

import Foundation
import UIKit

class MyTableViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var memes: [Meme]!
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
    }
    // MARK: Table View Data Source
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
 //If sent memes is zero go to editor  I thought again and again this is the way I had a choice to go by the instuction but since this keep f n coming back I will commennt this out with the hope to move beyond project two in this cohort I will be sure to make specific comment about carity of assignment and grading standands which are questionable
//        if memes.count == 0 {
//            performSegueWithIdentifier("TabTooEditor", sender: self)
//   
//        }
        tableView.reloadData()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
        
        //Load Meme with Meme daat for table view
        let CellID = "MemeCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID, forIndexPath: indexPath) as! UITableViewCell
        
        let meme = self.memes[indexPath.row]
        
        cell.textLabel!.text = meme.topText
        cell.detailTextLabel!.text = meme.bottomText
        cell.imageView?.image = meme.memedImage
        
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // If cell selected goto detail veiw of Meme
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("detailVC") as! MemeDetailsViewContoller
        
        let meme = self.memes[indexPath.row]
        detailController.meme = meme
        detailController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailController, animated: true)
        
    }
    @IBAction func dissmiss(sender: AnyObject) {
     // If press action go to editor
        
        
     performSegueWithIdentifier("TabTooEditor", sender: self)
    }
    
    
}




















