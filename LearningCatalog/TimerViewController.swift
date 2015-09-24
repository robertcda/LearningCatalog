//
//  TimerViewController.swift
//  LearningCatalog
//
//  Created by Robert on 24/09/15.
//  
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var timeLbl: UILabel!
    
    var timer:NSTimer?
    var count = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetTimer(UIAlertAction())
        self.title = "Timer Experiment"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool){
        timer?.invalidate()
        super.viewWillDisappear(animated);
    }

    func updateLabel(){
        timeLbl.text = "\(count)"
    }
    
    func timerFired(){
        count--
        updateLabel()

        if count <= 0{
            timer?.invalidate()
            showAlert(title: "Timer", content: "Timer Completed")
        }
    }

    // MARK: user alerts and utility
    func showAlert(title alertTitle:String,content alertContent:String){
        self.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        let emptyField: UIAlertController = UIAlertController(title: alertTitle, message: alertContent, preferredStyle: .Alert)
        emptyField.addAction(UIAlertAction(title: "Reset", style: .Default , handler: resetTimer))
        emptyField.addAction(UIAlertAction(title: "Back", style: .Cancel, handler: handlerForPopping))

        self.presentViewController(emptyField, animated: true, completion: nil)
    }
    
    func resetTimer(action:UIAlertAction){
        count = 10
        updateLabel()
        timer =  NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerFired", userInfo: nil, repeats: true)
    }

    
    func handlerForPopping(action:UIAlertAction){
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
