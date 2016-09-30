//
//  WebViewController.swift
//  SportsTriviaGame
//
//  Created by Alexander Nelson on 9/29/16.
//  Copyright © 2016 Jetwolfe Labs. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    var url = ""
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let requestURL = NSURL(string: url)
        let request = NSURLRequest(url:requestURL as! URL)
            webView.loadRequest(request as URLRequest)
    }

    @IBAction func closeWebView(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

}
