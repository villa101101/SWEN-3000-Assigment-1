//
//  Explorer.swift
//  FileExplorer
//
//  Created by administritor on 2019/5/2.
//  Copyright © 2019 GIC. All rights reserved.
//

import Foundation

class Explorer {
    var folders = [String]()
    var files = [String]()
    var current:String = ""
    var parent:String = ""
    
    func getfolders(array: [String]){
        folders.insert(contentsOf: array, at: 0)
    }
    func getfoldernum() -> Int {
        return folders.count
    }
    func getfiles(array: [String]){
        folders.insert(contentsOf: array, at: 0)
    }
    func getfilenum() -> Int {
        return files.count
    }
    func getDisplayAmount() -> Int {
        return files.count + folders.count
    }
}
