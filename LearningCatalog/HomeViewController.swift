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
    func calledFromDelegate(_ message:String)
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
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.displayDeviceOrientation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    func getSessions (){
        let filePath = Bundle.main.path(forResource: "Resource", ofType: "plist")
        arrSessions = NSMutableArray(contentsOfFile: filePath!)
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Tableview delegates and datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrSessions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: .default, reuseIdentifier: "homeCell")
        cell.textLabel!.text = arrSessions[indexPath.row] as? String
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func subjectSelected() -> String{
        return arrSessions.object(at: tableView.indexPathForSelectedRow!.row) as! String
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let subSelectedValue = subjectSelected()
        switch subSelectedValue
        {
        case "Notification":
            showAlert(title: "Notification", content: "A Notification would have been posted by the app.")
            showLocalNotification("Notification Test!!")
        case "Orientation":
            displayDeviceOrientation()
        case "WebView":
            self.performSegue(withIdentifier: "webView", sender: nil)
        case "Timer":
            self.performSegue(withIdentifier: "timer", sender: nil)
        case "NetworkRequest":
            self.performSegue(withIdentifier: "jsonSegue", sender: nil)
        case "Maps":
            self.performSegue(withIdentifier: "mapViewSegue", sender: nil)
        default:
            self.delegate?.calledFromDelegate("Hey Delegate !! I recieved (\(subSelectedValue)). Do you know about this?")
        }
    }
    
    // MARK: Orientation
    
    func displayDeviceOrientation(){
        if subjectSelected() == "Orientation"{
            if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)){
                showAlert(title: "Orientation", content: "Landscape")
            }else if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)){
                showAlert(title: "Orientation", content: "Portrait")
            }
        }
    }
    
    // MARK: Notification
    func showLocalNotification(_ bodyContent: String)    {
        UIApplication.shared.cancelAllLocalNotifications()
        
        let notiication = UILocalNotification()
        notiication.alertBody = bodyContent
        notiication.alertAction = "Open"
        notiication.fireDate = Date()
        notiication.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notiication)
    }
    
    // MARK: utility methods
    
    func showAlert(title alertTitle:String,content alertContent:String){
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        let emptyField: UIAlertController = UIAlertController(title: alertTitle, message: alertContent, preferredStyle: .alert)
            emptyField.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(emptyField, animated: true, completion: nil)
    }
}

