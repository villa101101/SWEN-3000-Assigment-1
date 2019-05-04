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
var currentIndex = 0
var fnames: [String] = [""]

class ViewController: UIViewController {
    
    let tb = UITableView(frame: UIScreen.main.bounds)
    let dispatchGroup = DispatchGroup()
    let dispatchGroup2 = DispatchGroup()


    override func viewDidLoad() {
        super.viewDidLoad()
//        loadGif()
        session()
        dispatchGroup.wait()
        
        view.addSubview(tb)
        tb.delegate = self
        tb.dataSource = self
    

    }
    
//    func loadGif() {
//        let jeremyGif = UIImage.gifImageWithName("giphy.gif")
//
//        let imageView = UIImageView(image: jeremyGif)
//        imageView.frame = CGRect(x: 20.0, y: 50.0, width: self.view.frame.size.width - 40, height: 150.0)
//        view.addSubview(imageView)
//    }
    
    func session() {
        dispatchGroup.enter()
        let urlString = "http://127.0.0.1:8000/?folder=/"
        let url = URL(string:urlString)
        
        let obj = Explorer()
        
        
        URLSession.shared.dataTask(with: url!){(data, response, error) in
            
            do  {
                let filesInfo = try JSONDecoder().decode(Breifcase.self, from: data!)
                obj.getfolders(array: filesInfo.folders)
                obj.getfiles(array: filesInfo.files)
                
                folderNum = obj.getDisplayAmount()
                callnames.removeAll()
                fnames.removeAll()
                
                callnames.append(contentsOf: obj.getFolderNames())
                callnames.append(contentsOf: obj.getFileNames())
                fnames.append(contentsOf: obj.getFolderNames())

                
                
                
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
        
//        let cellFullname = UITableViewCell()
//        if indexPath.row == 0{
//            cell= tableView.
//            cell.backgroundColor = UIColor.green
//        } else {
//            cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
//            cell.backgroundColor = UIColor.black
//        }
//        cell.backgroundColor = UIColor.darkGray
        
//        let cellFullname = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BetterTableViewCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BetterTableViewCell")
        
        
        cell?.textLabel?.text = callnames[indexPath.row]
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "File Explorer"
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        if (currentIndex < fnames.count){
            session2()
            dispatchGroup2.wait()
            Toast.show(message: "done", controller: self)
            tb.reloadData()
        } else {
            Toast.show(message: "This is a file, there is no subdirectory available", controller: self)
        }
        
       
        
        
        
        
        
        
        
    
        
    }
    
    func session2() {
        dispatchGroup2.enter()
        let urlString = "http://127.0.0.1:8000/?folder=/"
        let parentUrl = urlString + fnames[currentIndex]
        let url = URL(string:parentUrl)
        
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
                
                
                
                
                self.dispatchGroup2.leave()
                
            }
                
            catch {
                print("We got an error")
            }
            
            
            }.resume()
        
        
    }
    
    
}


class Toast {
    static func show(message: String, controller: UIViewController) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25;
        toastContainer.clipsToBounds  =  true
        
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        
        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])
        
        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)
        controller.view.addConstraints([c1, c2, c3])
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
