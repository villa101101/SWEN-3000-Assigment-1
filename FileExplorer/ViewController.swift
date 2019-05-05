//
//  ViewController.swift
//  FileExplorer
//
//  Created by kj on 2019/4/21.
//  Copyright © 2019 GIC. All rights reserved.
//

import UIKit
import Foundation

//count the amout of items in the current folder
var folderNum: Int = 0
//name of all the items in the current folder
var callnames: [String] = [""]
var currentIndex = 0
//name of all the subfolders in the current folder
var fnames: [String] = [""]
//current folder address
var currentdir = ""
//parent directory
var Parentlink = ""

class ViewController: UIViewController {
    
    let tb = UITableView(frame: UIScreen.main.bounds)
    let dispatchGroup = DispatchGroup()
    let dispatchGroup2 = DispatchGroup()
    let dispatchGroup3 = DispatchGroup()


    override func viewDidLoad() {
        super.viewDidLoad()
        session()
        dispatchGroup.wait()
        
        view.addSubview(tb)
        tb.delegate = self
        tb.dataSource = self
    

    }
 //makes a connection the first time the user opens the app
    func session() {
        dispatchGroup.enter()
        let urlString = "http://127.0.0.1:8000/?folder=/"
        let url = URL(string:urlString)
        
        let obj = Explorer()
        
        
        URLSession.shared.dataTask(with: url!){(data, response, error) in
            
            do  {
                //use the struct called Breifcase to collect the json data that is decoded
                let filesInfo = try JSONDecoder().decode(Breifcase.self, from: data!)
                obj.getfolders(array: filesInfo.folders)
                obj.getfiles(array: filesInfo.files)
                obj.setCurrent(value: filesInfo.current)
                obj.setParent(value: filesInfo.parent)
                
                folderNum = obj.getDisplayAmount()
                callnames.removeAll()
                fnames.removeAll()
                
                callnames.append(contentsOf: obj.getFolderNames())
                callnames.append(contentsOf: obj.getFileNames())
                fnames.append(contentsOf: obj.getFolderNames())
                currentdir = obj.getCurrent()
                Parentlink = obj.getParent()
                

                
                
                
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
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        let lab = UILabel()
        let button = UIButton(type: .custom)

        vw.backgroundColor = UIColor(red: 0.7529, green: 0.8941, blue: 0.9686, alpha: 1.0) /* #c0e4f7 */

        lab.text = "File Explorer"
        lab.textAlignment = .center
        lab.font = UIFont(name: lab.font.fontName, size: 20)
        lab.textColor = UIColor.purple
        

        button.setImage(UIImage(named: "backButton"), for: .normal) // Image can be downloaded from here below link
        button.setTitle("Back", for: .normal)
        button.setTitleColor(button.tintColor, for: .normal) // You can change the TitleColor
        button.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        
        if (currentdir == "/" || currentdir == "" ){
            
            
            vw.addSubview(lab)
            
            lab.translatesAutoresizingMaskIntoConstraints = false
            lab.centerXAnchor.constraint(equalTo: vw.centerXAnchor).isActive = true
            lab.bottomAnchor.constraint(equalTo: vw.bottomAnchor).isActive = true
            lab.widthAnchor.constraint(equalTo: vw.widthAnchor, multiplier: 0.4).isActive = true
            lab.heightAnchor.constraint(equalTo: vw.heightAnchor, multiplier: 0.4).isActive = true
            
            
        } else {
            vw.addSubview(lab)
            vw.addSubview(button)
            
            lab.translatesAutoresizingMaskIntoConstraints = false
            lab.centerXAnchor.constraint(equalTo: vw.centerXAnchor).isActive = true
            lab.bottomAnchor.constraint(equalTo: vw.bottomAnchor).isActive = true
            lab.widthAnchor.constraint(equalTo: vw.widthAnchor, multiplier: 0.4).isActive = true
            lab.heightAnchor.constraint(equalTo: vw.heightAnchor, multiplier: 0.4).isActive = true
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.leftAnchor.constraint(equalTo: vw.leftAnchor).isActive = true
            button.widthAnchor.constraint(equalTo: vw.widthAnchor, multiplier: 0.2).isActive = true
            button.heightAnchor.constraint(equalTo: vw.heightAnchor, multiplier: 0.3).isActive = true
        }
        


        return vw
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cells")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cells")
        
        
        cell?.textLabel?.text = callnames[indexPath.row]
        
        if (indexPath.row % 2 == 0) { cell?.backgroundColor = UIColor(red: 0, green: 0.5882, blue: 0.9294, alpha: 1.0)
        } else {
            cell?.backgroundColor = UIColor(red: 0, green: 0.8549, blue: 0.9882, alpha: 1.0)
        }
        
        if (indexPath.row < fnames.count) {
            cell?.accessoryType = .disclosureIndicator
        } else {
            cell?.accessoryType = .detailButton
        }
        
        
        
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
            
            tb.reloadData()
        } else {
            Toast.show(message: "This is a file, there is no subdirectory available", controller: self)
        }
        
        
    }
    
    //called each time the user navigates through the file explorer
    func session2() {
        dispatchGroup2.enter()
        if (currentdir.count > 1){
            currentdir.remove(at: currentdir.startIndex)
        } else {
            currentdir = ""
        }
        
        
        let subUrl = currentdir
        let urlString = "http://127.0.0.1:8000/?folder=/"
        let parentUrl = urlString + subUrl + "/" + fnames[currentIndex]
        let url = URL(string:parentUrl)
        
        
        
        let obj = Explorer()
        
        
        URLSession.shared.dataTask(with: url!){(data, response, error) in
            
            do  {
                let filesInfo = try JSONDecoder().decode(Breifcase.self, from: data!)
                obj.getfolders(array: filesInfo.folders)
                obj.getfiles(array: filesInfo.files)
                obj.setCurrent(value: filesInfo.current)
                obj.setParent(value: filesInfo.parent)
                
                folderNum = obj.getDisplayAmount()
                callnames.removeAll()
                fnames.removeAll()
                
                callnames.append(contentsOf: obj.getFolderNames())
                callnames.append(contentsOf: obj.getFileNames())
                fnames.append(contentsOf: obj.getFolderNames())
                currentdir = obj.getCurrent()
                Parentlink = obj.getParent()
                
                
                
                
                self.dispatchGroup2.leave()
                
            }
                
            catch {
                print("We got an error")
            }
            
            
            }.resume()
        
        
    }
    
    func previousFolder() {
        dispatchGroup3.enter()
        if (currentdir.count > 1){
            currentdir.remove(at: currentdir.startIndex)
        } else {
            currentdir = ""
        }
        
        let subUrl = Parentlink
        let urlString = "http://127.0.0.1:8000/?folder=/"
        let parentUrl = urlString + subUrl 
        let url = URL(string:parentUrl)
        
        
        let obj = Explorer()
        
        
        URLSession.shared.dataTask(with: url!){(data, response, error) in
            
            do  {
                let filesInfo = try JSONDecoder().decode(Breifcase.self, from: data!)
                obj.getfolders(array: filesInfo.folders)
                obj.getfiles(array: filesInfo.files)
                obj.setCurrent(value: filesInfo.current)
                obj.setParent(value: filesInfo.parent)
                
                folderNum = obj.getDisplayAmount()
                callnames.removeAll()
                fnames.removeAll()
                
                callnames.append(contentsOf: obj.getFolderNames())
                callnames.append(contentsOf: obj.getFileNames())
                fnames.append(contentsOf: obj.getFolderNames())
                currentdir = obj.getCurrent()
                Parentlink = obj.getParent()
                
                
                
                
                self.dispatchGroup3.leave()
                
            }
                
            catch {
                print("We got an error")
            }
            
            
            }.resume()
        
        
    }
    
//    func addBackButton() {
//        let backButton = UIButton(type: .custom)
//        backButton.setImage(UIImage(named: "backButton"), for: .normal) // Image can be downloaded from here below link
//        backButton.setTitle("Back", for: .normal)
//        backButton.setTitleColor(backButton.tintColor, for: .normal) // You can change the TitleColor
//
//
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
//    }
    
    @IBAction func backAction(_ sender: UIButton) {
//        let _ = self.navigationController?.popViewController(animated: true)
        previousFolder()
        dispatchGroup3.wait()
        tb.reloadData()
    }
    
}

//use to manage a toast
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
