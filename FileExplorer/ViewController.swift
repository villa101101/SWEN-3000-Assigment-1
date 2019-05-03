//
//  ViewController.swift
//  FileExplorer
//
//  Created by kj on 2019/4/21.
//  Copyright © 2019 GIC. All rights reserved.
//

import UIKit
import Foundation

var folderNum: Int = 0
var callnames: [String] = [""]

class ViewController: UIViewController {
    
    let tb = UITableView(frame: UIScreen.main.bounds)
    let dispatchGroup = DispatchGroup()


    override func viewDidLoad() {
        super.viewDidLoad()
        session()
        dispatchGroup.wait()
        
        view.addSubview(tb)
        tb.delegate = self
        tb.dataSource = self
        tb.reloadData()

    }
    
    func session() {
        dispatchGroup.enter()
        let urlString = "http://127.0.0.1:8000/"
        let url = URL(string:urlString)
        
        let obj = Explorer()
        
        
        URLSession.shared.dataTask(with: url!){(data, response, error) in
            
            do  {
                let filesInfo = try JSONDecoder().decode(Breifcase.self, from: data!)
                obj.getfolders(array: filesInfo.folders)
                obj.getfiles(array: filesInfo.files)
                
                folderNum = obj.getDisplayAmount()
                callnames.removeAll()
                
                callnames.append(contentsOf: obj.getFolderNames())
                callnames.append(contentsOf: obj.getFileNames())

                
                
                
                self.dispatchGroup.leave()
                
            }
                
            catch {
                print("We got an error")
            }
            
            
            }.resume()
        
        
    }
    
    struct Breifcase: Decodable {
        var folders = [String]()
        var files = [String]()
        var current:String
        var parent:String
        
    }
    
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellFullname = UITableViewCell()
//        if indexPath.row == 0{
//            cell= tableView.
//            cell.backgroundColor = UIColor.green
//        } else {
//            cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
//            cell.backgroundColor = UIColor.black
//        }
//        cell.backgroundColor = UIColor.darkGray
        
//        let cellFullname = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        
        
        cellFullname.textLabel?.text = callnames[indexPath.row]
        
        return cellFullname
        
//        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "File Explorer"
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75.0
    }
    
    
}

