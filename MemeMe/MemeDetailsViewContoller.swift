//
//  MemeDetailsViewContoller.swift
//  MemeMe
//
//  Created by Neal Rollins on 5/31/15.
//  Copyright (c) 2015 Neal Rollins. All rights reserved.
//



import UIKit

class MemeDetailsViewContoller: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var meme: Meme!
    // Hide botton tab bar will view apaers
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = true
        
        imageView!.image = meme.memedImage
        
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.hidden = false
    }
    
        
    
}