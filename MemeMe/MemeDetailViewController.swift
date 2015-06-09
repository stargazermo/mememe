//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by MoXiafang on 6/6/15.
//  Copyright (c) 2015 MoXiafang. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    override func viewWillAppear(animated: Bool) {
        imageView.image = meme.memedImage
        //hide the tab bar, nav bar and tool bar to show the full screen image
        tabBarController?.tabBar.hidden = true
        navigationController?.navigationBar.hidden = true
        toolBar.hidden = true
    }
    
    //tap to show nav bar and tool bar
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        if toolBar.hidden == true && navigationController?.navigationBar.hidden == true {
            toolBar.hidden = false
            navigationController?.navigationBar.hidden = false
        } else {
            toolBar.hidden = true
            navigationController?.navigationBar.hidden = true
        }
        
    }
    
    //going back to meme editor, showing the original image and texts
    @IBAction func editMeme(sender: AnyObject) {
        var memeEditor = storyboard?.instantiateViewControllerWithIdentifier("memeEditor") as! MemeEditorViewController
        memeEditor.meme = meme
        presentViewController(memeEditor, animated: true, completion: nil)
    }
    
    @IBAction func deleteMeme(sender: AnyObject) {
        if let index = find(appDelegate.memes, meme) {
            appDelegate.memes.removeAtIndex(index)
        }
        //move back to the sent memes page after delete the current meme
        if let navigationcontroller = self.navigationController {
            navigationcontroller.popToRootViewControllerAnimated(true)
        }
    }
    
}
