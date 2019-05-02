//
//  ViewController.swift
//  FileExplorer
//
//  Created by kj on 2019/4/21.
//  Copyright © 2019 GIC. All rights reserved.
//

import UIKit
import Foundation
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
//    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        webView.uiDelegate = self
//        webView.navigationDelegate = self
//
//        let url = Bundle.main.url(forResource: "http://127.0.0.1:8000/?folder", withExtension: "html")!
//        webView.loadFileURL(url, allowingReadAccessTo: url)
//        let request = URLRequest(url: url)
//        webView.load(request)
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        
        do {
            let items = try fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                print("Found \(item)")
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }


}
}

