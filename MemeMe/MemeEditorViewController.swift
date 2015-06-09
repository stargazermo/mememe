//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by MoXiafang on 6/5/15.
//  Copyright (c) 2015 MoXiafang. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var meme: Meme!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.blackColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the text delegate
        topText.delegate = self
        bottomText.delegate = self
        
        // Set textField text attributes.
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        //prepare for image for editing more from detail view
        if meme != nil {
            imageView.image = meme.originalImage
            topText.text = meme.topText
            bottomText.text = meme.bottomText
        } else {
            shareButton.enabled = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        //disable the camera button if no camera is available
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        //call to subscribe keyboard notifications
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //call to unsubscribe keyboard notifications
        self.unsubscribeFromKeyboardNotifications()
    }
    
    //subscribe notifications when keyboard appears and disappears
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //subscribe keyboard notifications when keyboard appears and disappears
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //slide the view up if the bottom text is being edited
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.editing
        {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //slide back to the original position when the bottom text is done editing
    func keyboardWillHide(notification: NSNotification) {
        if bottomText.editing
        {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    //get the key board height to determine how much to slide up
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    //pick an image from the album
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        let albumImagePicker = UIImagePickerController()
        albumImagePicker.delegate = self
        albumImagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(albumImagePicker, animated: true, completion: nil)
    }
    
    //pick an image from the camera
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        let cameraImagePicker = UIImagePickerController()
        cameraImagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(cameraImagePicker, animated: true, completion: nil)
    }
    
    //an image has been selected from the picker, display the selected image in the meme editor
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            shareButton.enabled = true
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //cancel the picking of the image on the editor view controller
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //dismiss keyboard when return key is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    //dismiss keyboard when users tap the screen outside of the keyboard.
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func saveMeme() {
        var meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        
        //render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let MemedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        return MemedImage
    }
    
    @IBAction func shareButtonClicked(sender: AnyObject) {
        let generatedMemedImage = generateMemedImage()
        
        let actcViewController = UIActivityViewController(activityItems: [generatedMemedImage], applicationActivities: nil)
        
        self.presentViewController(actcViewController, animated: true, completion: nil)
        actcViewController.completionWithItemsHandler = {(activity: String!, completed: Bool, items: [AnyObject]!, error: NSError!) -> Void in
            //save meme only when an action is completed
            if completed {
                self.saveMeme()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
}
