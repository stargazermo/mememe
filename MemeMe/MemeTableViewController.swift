//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by MoXiafang on 6/6/15.
//  Copyright (c) 2015 MoXiafang. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add an Edit button to the nav bar.
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
        //show tab bar when view is shown
        tabBarController?.tabBar.hidden = false
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as! UITableViewCell
        let meme = appDelegate.memes[indexPath.row]

        //set image and text for the table view cell.
        cell.imageView!.image = meme.memedImage
        cell.textLabel!.text = meme.topText + " " + meme.bottomText

        return cell
    }
    
    //showing the detail view
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var detailVC = storyboard?.instantiateViewControllerWithIdentifier("detailView") as! MemeDetailViewController
        detailVC.meme = appDelegate.memes[indexPath.row]
        navigationController!.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            appDelegate.memes.removeAtIndex(indexPath.row)
            //reload data so the view will be updated
            tableView.reloadData()
        }
    }
    
    //Moves to Meme Editor when button clicked
    @IBAction func addMeme(sender: AnyObject) {
        var memeEditor = storyboard?.instantiateViewControllerWithIdentifier("memeEditor") as! MemeEditorViewController
        presentViewController(memeEditor, animated: true, completion: nil)
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

}
