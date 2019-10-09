//
//  WebViewController.swift
//  gank_swift
//
//  Created by keith on 2019/2/28.
//  Copyright © 2019 keith. All rights reserved.
//

import UIKit
import WebKit
import PKHUD

class WebViewController: UIViewController, WKNavigationDelegate {

    public var url:String = ""
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self
        if !self.url.isEmpty {
            PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
            PKHUD.sharedHUD.show(onView: self.view)
            let u = URL(string: self.url)
            let request: URLRequest = URLRequest(url:u!)
            self.webView.load(request)
        }
        // Do any additional setup after loading the view.
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        PKHUD.sharedHUD.hide()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
