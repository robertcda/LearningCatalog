//
//  WebViewController.swift
//  LearningCatalog
//
//  Created by Robert on 24/09/15.
//  
//

import UIKit

class WebViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var url:URL = URL(string: "https://www.google.com")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requestObj = URLRequest(url: url)
        webView.loadRequest(requestObj)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - WebView delgate
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        print("\(#function)")
    }

    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        print("\(#function)")
    }
    
    func webView(_ webView: UIWebView,
        didFailLoadWithError error: Error)
    {
        print("\(#function)")        
        
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        if let tmpUrl = request.url
        {
            url = tmpUrl
            print("loading url \(url)")
        }else
        {
            print("url is empty")
        }
        
        return true
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
