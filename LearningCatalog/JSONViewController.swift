//
//  JSONViewController.swift
//  LearningCatalog
//
//  Created by Robert on 24/09/15.
//  
//

import UIKit

class JSONViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var jsonContentTextView: UITextView!
    @IBOutlet weak var keyPathToTraverseTextField: UITextField!
    @IBOutlet weak var traversedContentTextView: UITextView!

    var responseData: NSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "JSON Fetching/Parsing"
        urlTextField.text = "http://api.geonames.org/postalCodeLookupJSON?postalcode=560029&country=IN&username=vivek"
        // Do any additional setup after loading the view.
    }

    @IBAction func urlFetchButtonClicked(sender: UIButton)
    {
        fetchJSONFromURL()
    }
    
    func computeTraversedPath(newString:String)
    {
        var textToAdd = ""

        if let uwResponseData = responseData{
            let valueGotFromJSON = jsonValueForKey(KeyPath: newString, jsonData: uwResponseData)
            textToAdd = "\(valueGotFromJSON)"
        }
        
        traversedContentTextView.text = textToAdd
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {

        if let textStringAsNSString = keyPathToTraverseTextField.text as NSString?
        {
            let newString1 = textStringAsNSString.stringByReplacingCharactersInRange(range, withString: string)
            computeTraversedPath(newString1)
        }
        
        return true
    }
    
    func fetchJSONFromURL()
    {
        /*
        http://api.geonames.org/postalCodeLookupJSON?postalcode=560029&country=IN&username=demo
        This is a sample link to just get some JSON response...
        */
        
        if let strURL = urlTextField.text
        {
            if let url = NSURL(string: strURL)
            {
                NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: url), queue: NSOperationQueue(), completionHandler:parseResp)
            }else
            {
                print(" Mostly an invalid URL\(strURL)")
            }
        }
    }

    
    // MARK: - JSON parsing.
    
    func parseResp(urlRespone:NSURLResponse?, responseData:NSData?, error:NSError?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let responseDataUnwrapped = responseData
            {
                self.jsonContentTextView.backgroundColor = UIColor.greenColor()
                self.responseData = responseData
                if let responseString = String(data: responseDataUnwrapped, encoding: NSASCIIStringEncoding)
                {
                    self.jsonContentTextView.text = responseString
                    self.traversedContentTextView.text = responseString
                    self.keyPathToTraverseTextField.text = ""
                }
                else
                {
                    self.jsonContentTextView.text = ""
                    self.traversedContentTextView.text = ""
                    self.keyPathToTraverseTextField.text = ""
                }
            }else
            {
                self.jsonContentTextView.text = ""
                self.traversedContentTextView.text = ""
                self.keyPathToTraverseTextField.text = ""
                
                self.jsonContentTextView.backgroundColor = UIColor.redColor()
                print ("\(error)")
            }
            
            self.computeTraversedPath("")
        })
    }
    
    func jsonValueForKey(KeyPath keyPath:String, jsonData:NSData) -> AnyObject
    {
        var returnedObject: AnyObject = ""

        do{
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments) as? NSDictionary
            
            if let jsonDictionary = jsonObject{
                if keyPath.isEmpty{
                    returnedObject = jsonDictionary
                }else
                {
                    if let object = jsonDictionary.valueForKey(keyPath){
                        returnedObject = object
                    }
                }
            }
        }
        catch{
            print(" Error : \(error) ")
        }
        
        return returnedObject
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
