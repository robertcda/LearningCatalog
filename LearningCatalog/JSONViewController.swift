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

    var responseData: Data?
    
    @IBAction func requestUsingURLConnection(_ sender: UIButton) {
        fetchJSONFromURL()
    }

    @IBAction func requestUsingURLSession(_ sender: UIButton) {
        fetchJSONFromSession()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "JSON Fetching/Parsing"
        urlTextField.text = "http://api.geonames.org/postalCodeLookupJSON?postalcode=560029&country=IN&username=vivek"
        // Do any additional setup after loading the view.
    }
    
    func computeTraversedPath(_ newString:String)
    {
        var textToAdd = ""

        if let uwResponseData = responseData{
            let valueGotFromJSON = jsonValueForKey(KeyPath: newString, jsonData: uwResponseData)
            textToAdd = "\(valueGotFromJSON)"
        }
        
        traversedContentTextView.text = textToAdd
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {

        if let textStringAsNSString = keyPathToTraverseTextField.text as NSString?
        {
            let newString1 = textStringAsNSString.replacingCharacters(in: range, with: string)
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
            if let url = URL(string: strURL)
            {
                NSURLConnection.sendAsynchronousRequest(URLRequest(url: url), queue: OperationQueue(), completionHandler:parseResp as! (URLResponse?, Data?, Error?) -> Void)
            }else
            {
                print(" Mostly an invalid URL\(strURL)")
            }
        }
    }

    func fetchJSONFromSession()
    {
        if let strURL = urlTextField.text
        {
            if let url = URL(string: strURL)
            {
                let request = URLRequest(url: url)
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                
                let task = session.dataTask(with: request, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
                    
                    self.responseData = data
                    self.updateUIWIthJSONResponse()
                    print("\(error)")
                    /*
                    if let responseFromServerData = data
                    {
                        let json = self.jsonValueForKey(KeyPath: "", jsonData: responseFromServerData)
                        print("\(json)")
                    }else
                    {
                        
                    }*/
                    
                } as! (Data?, URLResponse?, Error?) -> Void)
                
                task.resume()
                
            }
        }
    }
    
    
    func updateUIWIthJSONResponse()
    {
        DispatchQueue.main.async(execute: {
                if let responseDataUnwrapped = self.responseData
                {
                    self.jsonContentTextView.backgroundColor = UIColor.green
                    if let responseString = String(data: responseDataUnwrapped, encoding: String.Encoding.ascii)
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
                    
                    self.jsonContentTextView.backgroundColor = UIColor.red
                }
                
                self.computeTraversedPath("")
        })
    }
    
    // MARK: - JSON parsing.
    
    func parseResp(_ urlRespone:URLResponse?, responseData:Data?, error:NSError?)
    {
        self.responseData = responseData
        print ("\(error)")
        self.updateUIWIthJSONResponse()
    }
    
    func jsonValueForKey(KeyPath keyPath:String, jsonData:Data) -> AnyObject
    {
        var returnedObject: AnyObject = "" as AnyObject

        do{
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? NSDictionary
            
            if let jsonDictionary = jsonObject{
                if keyPath.isEmpty{
                    returnedObject = jsonDictionary
                }else
                {
                    if let object = jsonDictionary.value(forKey: keyPath){
                        returnedObject = object as AnyObject
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
