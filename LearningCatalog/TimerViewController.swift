//
//  TimerViewController.swift
//  LearningCatalog
//
//  Created by Robert on 24/09/15.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var timeLbl: UILabel!
    
    var timer:NSTimer?
    var count = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Timer Experiment"
        count = 10
        updateLabel()
        timer =  NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerFired", userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updateLabel()
    {
        print("\(__FUNCTION__)")
        timeLbl.text = "\(count)"
    }
    
    func timerFired()
    {
        print("\(__FUNCTION__)")
        count--
        updateLabel()

        if count <= 0
        {
            timer?.invalidate()
            
            showAlert(title: "Timer", content: "Timer Completed")
            
        }
    }

    func showAlert(title alertTitle:String,content alertContent:String){
        
        self.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        
        let emptyField: UIAlertController = UIAlertController(title: alertTitle, message: alertContent, preferredStyle: .Alert)
        emptyField.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: handlerForPopping))
        
        self.presentViewController(emptyField, animated: true, completion: nil)
        
    }
    
    func handlerForPopping(action:UIAlertAction)
    {
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
