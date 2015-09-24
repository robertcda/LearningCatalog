//
//  HomeViewController.swift
//  LearningCatalog
//
//  Created by Robert on 23/09/15.
//  
//

import Foundation
import UIKit

@objc protocol HomeViewDelegate {
    func calledFromDelegate(message:String)
}

class HomeViewController: UITableViewController {
    
    weak var delegate:HomeViewDelegate?
    
    var arrSessions: NSMutableArray!
    var userName: String!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        getSessions()
        self.title = "[\(userName)]"
        
        /* Notification for userNotification... */
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayDeviceOrientation", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func getSessions (){
        let filePath = NSBundle.mainBundle().pathForResource("Resource", ofType: "plist")
        arrSessions = NSMutableArray(contentsOfFile: filePath!)
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Tableview delegates and datasource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrSessions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "homeCell")
        cell.textLabel!.text = arrSessions[indexPath.row] as? String
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    func subjectSelected() -> String{
        return arrSessions.objectAtIndex(tableView.indexPathForSelectedRow!.row) as! String
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let subSelectedValue = subjectSelected()
        switch subSelectedValue
        {
        case "Notification":
            showAlert(title: "Notification", content: "A Notification would have been posted by the app.")
            showLocalNotification("Notification Test!!")
        case "Orientation":
            displayDeviceOrientation()
        case "WebView":
            self.performSegueWithIdentifier("webView", sender: nil)
        case "Timer":
            self.performSegueWithIdentifier("timer", sender: nil)
        case "JSON Parsing":
            self.performSegueWithIdentifier("jsonSegue", sender: nil)

        default:
            self.delegate?.calledFromDelegate("Hey Delegate !! I recieved (\(subSelectedValue)). Do you know about this?")
        }
    }
    
    // MARK: Orientation
    
    func displayDeviceOrientation(){
        if subjectSelected() == "Orientation"{
            if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)){
                showAlert(title: "Orientation", content: "Landscape")
            }else if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)){
                showAlert(title: "Orientation", content: "Portrait")
            }
        }
    }
    
    // MARK: Notification
    func showLocalNotification(bodyContent: String)    {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        let notiication = UILocalNotification()
        notiication.alertBody = bodyContent
        notiication.alertAction = "Open"
        notiication.fireDate = NSDate()
        notiication.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notiication)
    }
    
    // MARK: utility methods
    
    func showAlert(title alertTitle:String,content alertContent:String){
        self.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
        let emptyField: UIAlertController = UIAlertController(title: alertTitle, message: alertContent, preferredStyle: .Alert)
            emptyField.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        self.presentViewController(emptyField, animated: true, completion: nil)
    }
}

