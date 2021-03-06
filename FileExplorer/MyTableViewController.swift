//
//  MyTableViewController.swift
//  FileExplorer
//
//  Created by administritor on 2019/5/2.
//  Copyright © 2019 GIC. All rights reserved.
//

import Foundation
import UIKit

class MyTableViewController: UITableViewController{
    
    let dispatchGroup = DispatchGroup()
    
    var folderNum: Int = 0
    
    override func viewDidLoad() {
        session()
        
        dispatchGroup.notify(queue: .main) {
        
        }
        print(folderNum)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderNum
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell
        if indexPath.row == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
            cell.backgroundColor = UIColor.green
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
            cell.backgroundColor = UIColor.black
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "File Explorer"
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75.0
    }
    
    
    func session() -> Void{
        dispatchGroup.enter()
        let urlString = "http://127.0.0.1:8000/"
        let url = URL(string:urlString)
        
        let obj = Explorer()
        
        
        URLSession.shared.dataTask(with: url!){(data, response, error) in
            
            do  {
                let filesInfo = try JSONDecoder().decode(Breifcase.self, from: data!)
                print(filesInfo.folders)
                obj.getfolders(array: filesInfo.folders)
                let b = obj.getfoldernum()
                print(b)
                obj.getfiles(array: filesInfo.files)
            
                self.folderNum = obj.getDisplayAmount()
                print(self.folderNum)
                self.dispatchGroup.leave()
            
            }
                
            catch {
                print("We got an error")
            }
            
            
            }.resume()
        
       
        

//        return self.folderNum
    }
    
    struct Breifcase: Decodable {
        var folders = [String]()
        var files = [String]()
        var current:String
        var parent:String
        
    }
    
    
}
