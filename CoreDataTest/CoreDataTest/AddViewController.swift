//
//  AddViewController.swift
//  CoreDataTest
//
//  Created by hwq on 2018/3/27.
//  Copyright © 2018年 hwq. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet var nameTextField : UITextField!
    @IBOutlet var detailTextField : UITextField!
    
    var people : PeopleMO!

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    @IBAction func saveButtonTapped(sender : UIButton) {
        if self.nameTextField.text?.count == 0 || detailTextField.text?.count == 0 {
            return
        }
        
        
        if  let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            
            people = PeopleMO(context: appDelegate.persistentContainer.viewContext)
            people.name = nameTextField.text
            people.detail = detailTextField.text
            
            appDelegate.saveContext()
        }
        self.navigationController?.popViewController(animated: true)
        //performSegue(withIdentifier: "unwindToHome", sender: self)
    }

}
