//
//  HomeViewController.swift
//  LearningCatalog
//
//  Created by Robert on 23/09/15.
//  Copyright © 2015 IBM. All rights reserved.
//

import Foundation
import UIKit

@objc protocol HomeViewDelegate {
    func calledFromDelegate()
}

class HomeViewController: UITableViewController {
    
     weak var delegate:HomeViewDelegate!
    
    var arrSessions: NSMutableArray!
    var userName: String!
    
    func getSessions ()
    {
        let filePath = NSBundle.mainBundle().pathForResource("Resource", ofType: "plist")
        arrSessions = NSMutableArray(contentsOfFile: filePath!)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getSessions()
        self.title = "Welcome \(userName)"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayDeviceOrientation", name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        /* JSON */
        
        jsonParsing()
    }
    
    func jsonParsing()
    {
        /*
        http://api.geonames.org/postalCodeLookupJSON?postalcode=560029&country=IN&username=demo
        */
        let strURL = "http://api.geonames.org/postalCodeLookupJSON?postalcode=560029&country=IN&username=vivek"
        let url = NSURL(string: strURL)
        if let url = url
        {
            let request = NSURLRequest(URL: url)
            
            /*
            NSURLConnection.sendAsynchronousRequest(<#T##request: NSURLRequest##NSURLRequest#>, queue: <#T##NSOperationQueue#>, completionHandler: <#T##(NSURLResponse?, NSData?, NSError?) -> Void#>)
            */
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:parseResp)
            
            
        }
//        let urlConnection = NSURLConnection
        
    
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Tableview delegates and datasource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrSessions.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "homeCell")
        cell.textLabel!.text = arrSessions[indexPath.row] as? String
        cell.accessoryType = .DisclosureIndicator
        return cell
    }
    
    func subjectSelected() -> String{
        return arrSessions.objectAtIndex(tableView.indexPathForSelectedRow!.row) as! String
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch subjectSelected()
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

        default:
            print("")
        }
    }
    
    // MARK: Orientation
    
    func displayDeviceOrientation()
    {
        if subjectSelected() == "Orientation"{
            if(UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)){
                showAlert(title: "Orientation", content: "Landscape")
            }else if(UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation)){
                showAlert(title: "Orientation", content: "Portrait")
            }
        }
    }
    
    // MARK: Timer
    func performTimerFunctionality(){
        showAlert(title: "Timer Functionality", content: "A Local notification will appear in about 3 seconds....")
         NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "timerFired", userInfo: nil, repeats: false)
    }
    
    func timerFired()
    {
        showAlert(title: "Timer Functionality", content: "Timer Fired")
        showLocalNotification("Timer Has Fired")
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
    
    // MARK: - JSON parsing.
    
    func parseResp(urlRespone:NSURLResponse?, responseData:NSData?, error:NSError?) {
        if let responseDataUnwrapped = responseData
        {
            let responseString = String(data: responseDataUnwrapped, encoding: NSASCIIStringEncoding)
            print(responseString)
            
            print(jsonValueForKey(KeyPath: "postalcodes", jsonData: responseDataUnwrapped))
        }else
        {
            print ("\(error)")
        }
    }
    
    func jsonValueForKey(KeyPath keyPath:String, jsonData:NSData) -> AnyObject
    {
        do{
          let jsonObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments) as? NSDictionary
            
            if let jsonDictionary = jsonObject
            {
                if keyPath.isEmpty
                {
                    return jsonObject!
                }else
                {
                    if let object = jsonObject?.valueForKey(keyPath)
                    {
                        return object
                    }
                }
            }
            
        }
        catch
        {
            print(" Error : \(error) ")
        }
        
        return "";
    }
    

    
}

