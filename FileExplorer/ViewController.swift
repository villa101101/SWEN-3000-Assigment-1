//
//  ViewController.swift
//  FileExplorer
//
//  Created by kj on 2019/4/21.
//  Copyright © 2019 GIC. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        sessionLoadData()



    }
    
    
    func sessionLoadData(){
        let urlString = "http://127.0.0.1:8000/"
        let url = URL(string:urlString)
        let request = URLRequest(url: url!)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request,
                                        completionHandler: {(data, response, error) -> Void in
                                            if error != nil{
                                                print(error.debugDescription)
                                            }else{
                                                let str = String(data: data!, encoding: String.Encoding.utf8)
                                                print(str)
                                            }
        }) as URLSessionTask
        
        dataTask.resume()
    }
}

