//
//  LoginViewController.swift
//  LearningCatalog
//
//  Created by Robert on 23/09/15.
//  Copyright © 2015 IBM. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,HomeViewDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let prefixedString  = ("string" as NSString).addPrefix("Whatever")
        print(prefixedString)
        ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func bthSignInTapped(sender: UIButton) {
        if txtEmail.text != "" && txtPassword.text != ""
        {
            if validatePasswordAndUserName(){
                self.performSegueWithIdentifier("showHomeView", sender: nil)
            }else{
                self.showAlert(title: "Invalid Login", content: "Invalid Login... \nHint(userName:1, Password: 2)")
            }
        }else{
            // Show some error..
            self.showAlert(title: "Empty Field", content: "User name/Password is empty")
        }
    }
    
    func showAlert(title alertTitle:String,content alertContent:String){
        let emptyField: UIAlertController = UIAlertController(title: alertTitle, message: alertContent, preferredStyle: .Alert)
        emptyField.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        self.presentViewController(emptyField, animated: true, completion: nil)
    }
    
    func validatePasswordAndUserName() -> Bool{
        if txtEmail.text == "1" && txtPassword.text == "2"{
            print("Login successful")
            return true
        }else{
            return false
        }
    }

    @IBAction func bthResetButtonTapped(sender: AnyObject) {
        txtEmail.text = ""
        txtPassword.text = ""
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showHomeView"{
            let controller = segue.destinationViewController as! HomeViewController
            controller.userName = txtEmail.text
            controller.delegate = self
        }
    }
    
    func calledFromDelegate()

    {
        print("hello hello hello")
    }
}

