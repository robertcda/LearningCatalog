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
    
    var timer:Timer?
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
    
    override func viewWillDisappear(_ animated: Bool){
        timer?.invalidate()
        super.viewWillDisappear(animated);
    }

    func updateLabel(){
        timeLbl.text = "\(count)"
    }
    
    func timerFired(){
        count -= 1
        updateLabel()

        if count <= 0{
            timer?.invalidate()
            showAlert(title: "Timer", content: "Timer Completed")
        }
    }

    // MARK: user alerts and utility
    func showAlert(title alertTitle:String,content alertContent:String){
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        
        let emptyField: UIAlertController = UIAlertController(title: alertTitle, message: alertContent, preferredStyle: .alert)
        emptyField.addAction(UIAlertAction(title: "Reset", style: .default , handler: resetTimer))
        emptyField.addAction(UIAlertAction(title: "Back", style: .cancel, handler: handlerForPopping))

        self.present(emptyField, animated: true, completion: nil)
    }
    
    func resetTimer(_ action:UIAlertAction){
        count = 10
        updateLabel()
        timer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerViewController.timerFired), userInfo: nil, repeats: true)
    }

    
    func handlerForPopping(_ action:UIAlertAction){
        self.navigationController?.popViewController(animated: true)
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
