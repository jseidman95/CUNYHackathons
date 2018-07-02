//
//  WebViewController.swift
//  CUNYHackathons
//
//  Created by Jesse Seidman on 12/11/17.
//  Copyright © 2017 Jesse Seidman. All rights reserved.
//

import UIKit
import WebKit

/*
 * This simple VC just contains a webview that presents the hackathon website that was passed to it
 */
class WebViewController: UIViewController
{
    //outlets
    @IBOutlet weak var webView: WKWebView!
    
    //vars
    public var urlString: String? = nil
    
    //automatically generated functions
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let urlString = urlString
        {
            if let url = URL(string: urlString)
            {
                if UIApplication.shared.canOpenURL(url)
                {
                    webView.load(URLRequest(url: url))
                }
            }
        }
    }
}
