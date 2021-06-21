//
//  ViewController.swift
//  JRKit
//
//  Created by jackfrow on 2021/5/31.
//

import UIKit
import Toast_Swift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let disk = GroupDisk()
        disk.fileName = "jack"
        disk.setObject(value: "123", key: "jack123")
        
    
    }
    
    @IBAction func toast(_ sender: Any) {
        
        
        self.view.makeToast("sadjlkasjaskdljdksaljsakdlj",title:"jack")
        
    }
    
    
}

