//
//  LoginViewController.swift
//  LearningCatalog
//
//  Created by Robert on 23/09/15.
//  
//

import UIKit

class LoginViewController: UIViewController,HomeViewDelegate {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        txtEmail.text = ""
        txtPassword.text = ""

        /* Extentions: To show prefixed string... */
        let prefixedString  = "string".addPrefix ("Whatever") ; print(prefixedString)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {

        txtEmail.text = ""
        txtPassword.text = ""

        super.viewWillAppear(animated)
    }
    @IBAction func bthSignInTapped(_ sender: UIButton) {
        if txtEmail.text != "" && txtPassword.text != ""
        {
            if validatePasswordAndUserName(){
                self.performSegue(withIdentifier: "showHomeView", sender: nil)
            }else{
                self.showAlert(title: "Invalid Login", content: "Invalid Login... \nHint(userName:1, Password: 2)")
            }
        }else{
            // Show some error..
            self.showAlert(title: "Empty Field", content: "User name/Password is empty")
        }
    }
    
    func showAlert(title alertTitle:String,content alertContent:String){
        let emptyField: UIAlertController = UIAlertController(title: alertTitle, message: alertContent, preferredStyle: .alert)
        emptyField.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(emptyField, animated: true, completion: nil)
    }
    
    func validatePasswordAndUserName() -> Bool{
        if txtEmail.text == "1" && txtPassword.text == "2"{
            print("Login successful")
            return true
        }else{
            return false
        }
    }

    @IBAction func bthResetButtonTapped(_ sender: AnyObject) {
        txtEmail.text = ""
        txtPassword.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHomeView"{
            let controller = segue.destination as! HomeViewController
            controller.userName = txtEmail.text
            controller.delegate = self
        }
    }
    
    func calledFromDelegate(_ message: String) {
        print("LoginViewControllerr: Recieved message[\(message)]")
    }
}

