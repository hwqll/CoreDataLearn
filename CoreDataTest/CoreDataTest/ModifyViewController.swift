//
//  ModifyViewController.swift
//  CoreDataTest
//
//  Created by hwq on 2018/3/27.
//  Copyright © 2018年 hwq. All rights reserved.
//

import UIKit

class ModifyViewController: UIViewController {
    
    @IBOutlet var name : UITextField!
    @IBOutlet var detail : UITextField!
    
    var people : PeopleMO!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.name.text = people.name
        self.detail.text = people.detail
    }
    
    @IBAction func modifyButtonTapped(sender : UIButton) {
        people.name = self.name.text
        people.detail = self.detail.text
        
        if  let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            print("修改数据")
            appDelegate.saveContext()
        }
        self.navigationController?.popViewController(animated: true)
    }

   
}
