//
//  ViewController.swift
//  MemeMe
//
//  Created by Neal Rollins on 5/24/15.
//  Copyright (c) 2015 Neal Rollins. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    
    // Text Field Delegate objects
    let textFieldDelegate = MyTextFieldDelegate()
    // store if keyboard is shifted
    var viewShifted = false
    var currentMeme : Meme!
  
    var sentMemes :[Meme]!
    @IBAction func cancel(sender: AnyObject) {
        
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.delegate = textFieldDelegate
        bottomTextField.delegate = textFieldDelegate
        
      // set share button
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "share")
        navigationItem.leftBarButtonItem?.enabled = false
        
        
    }
    func share ()
    {
        // go back to editor if any meme iput is nil
        if topTextField.text != nil {
            if bottomTextField.text != nil {
                if imageView.image != nil {
                    topTextField.text as NSString
                    
                    
                    UIActivityItemProvider(placeholderItem: topTextField.text!)
                    let memedImage = generateMemedImage()
                    
                    currentMeme =   Meme(topText: topTextField.text, bottomText : bottomTextField.text, oringinalImage : imageView.image! ,memedImage : memedImage)
                    
                    let activityController = UIActivityViewController(activityItems: [ topTextField.text! as NSString ,bottomTextField.text as NSString, memedImage ], applicationActivities: nil)
                    activityController.completionWithItemsHandler = {(activityType:String!, completed: Bool, returnedItems: [AnyObject]!, error: NSError!) in
                       
                        // if sucess activy the do this display shared memes
                        if completed {
                            self.save()
                            
                            
                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                            
                          self.navigationController?.popToRootViewControllerAnimated(true)
                            
                            
                            
                            
                         // if not sucsecfull then go back to editor if sent memes 
                        }else
                        {
                                self.dismissViewControllerAnimated(true, completion: nil)                            
                            if self.sentMemes != nil{
                                
                                self.navigationController?.popToRootViewControllerAnimated(true)
                            }
                        }
                    }
                    self.presentViewController(activityController, animated: true, completion: nil)
                }else{topTextField.text = "TOP"
                    bottomTextField.text = "BOTTOM"
                    
                    navigationItem.leftBarButtonItem?.enabled = false                }
            }else{topTextField.text = "TOP"
                bottomTextField.text = "BOTTOM"
                
                navigationItem.leftBarButtonItem?.enabled = false               }
            
        }else{topTextField.text = "TOP"
            bottomTextField.text = "BOTTOM"
            
            navigationItem.leftBarButtonItem?.enabled = false           }
    }
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        navigationItem.leftBarButtonItem?.enabled = false
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        // set attribute abd labesl
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        
        bottomTextField.textAlignment = NSTextAlignment.Center
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(animated: Bool) {
        
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification , object: nil)
        
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder(){
            
            view.frame.origin.y -= getKeyboardHeight(notification)
            viewShifted = true
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if viewShifted {
            
            navigationItem.leftBarButtonItem?.enabled = true
            view.frame.origin.y += getKeyboardHeight(notification)
            
            viewShifted = false
        }
    }
    func save() {
        
        
        //Create the meme
        var meme = Meme(topText: currentMeme.topText, bottomText : currentMeme.bottomText, oringinalImage : currentMeme.oringinalImage ,memedImage : currentMeme.memedImage)
        
        // Add it to the memes array in the Application Delegate
        (UIApplication.sharedApplication().delegate as!
            AppDelegate).memes.append(meme)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        sentMemes = appDelegate.memes
        
        
    }
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    func generateMemedImage() -> UIImage {
        
        navigationController?.navigationBarHidden = true
        toolBar.hidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navigationController?.navigationBarHidden = false
        toolBar.hidden = false
        
        return memedImage
    }
    
    // get key board
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
        
    }
    
    
    func setTabBarVisible (visible: Bool , animated: Bool){
        
        
        if ( tabBarIsVisible() == visible){return }
        
        let frame = tabBarController?.tabBar.frame
        
        
        let height = frame?.size.height
        
        let offsetY = (visible ? -height! :height)
        let duration: NSTimeInterval = (animated ? 0.3 : 0.0)
        
        if frame != nil {
            
            UIView.animateWithDuration(duration){
                
                self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, offsetY!)
                return
            }
        }
        
        
        
        
    }
    
    func tabBarIsVisible() -> Bool{
        
        
        return tabBarController?.tabBar.frame.origin.y < CGRectGetMaxY(view.frame)
        
        
    }
    
    
}

