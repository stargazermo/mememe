//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by MoXiafang on 6/6/15.
//  Copyright (c) 2015 MoXiafang. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        collectionView!.reloadData()
        //show tab bar when view is shown
        tabBarController?.tabBar.hidden = false
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //create a CollectionViewCell that links to the cell created in Main Storyboard
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = appDelegate.memes[indexPath.row]
        
        cell.imageView.image = meme.memedImage
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if editing {
            //delete from data source.
            appDelegate.memes.removeAtIndex(indexPath.row)
            //reload data to update the collection view
            collectionView.reloadData()
        } else {
            //showing the detail view
            var detailVC = storyboard?.instantiateViewControllerWithIdentifier("detailView") as! MemeDetailViewController
            detailVC.meme = appDelegate.memes[indexPath.row]
            navigationController!.pushViewController(detailVC, animated: true)
        }
    }
    
    //Moves to Meme Editor when button clicked
    @IBAction func addMeme(sender: AnyObject) {
        var memeEditor = storyboard?.instantiateViewControllerWithIdentifier("memeEditor") as! MemeEditorViewController
        presentViewController(memeEditor, animated: true, completion: nil)
    }
    
}
