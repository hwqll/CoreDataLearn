//
//  ViewController.swift
//  CoreDataTest
//
//  Created by hwq on 2018/3/27.
//  Copyright © 2018年 hwq. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var emptyView : UIView!
    @IBOutlet var tableView : UITableView!
    
    var peoples : [PeopleMO] = []
    
    var  fetchResultController :NSFetchedResultsController<PeopleMO>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.backgroundView = emptyView
        self.emptyView.isHidden = true
        
        self.loadDataFromCoreData()
        
    }
    /**从数据库载入数据*/
    func loadDataFromCoreData() {
        let fetchRequest :NSFetchRequest<PeopleMO> = PeopleMO.fetchRequest()
        let sort = NSSortDescriptor(key: "name", ascending: true)//数据排序
        fetchRequest.sortDescriptors = [sort]
        
        if  let appdelegate = UIApplication.shared.delegate as? AppDelegate {
             fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appdelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    peoples = fetchedObjects
                }
            }catch {
                print(error)
            }
            
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let modifyController = segue.destination as! ModifyViewController
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                modifyController.people = self.peoples[indexPath.row]
            }
            
        }
    }

    //MARK: - table view delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        if peoples.count > 0 {
            self.emptyView.isHidden = true
           self.tableView.separatorStyle = .singleLine
        }else {
            self.emptyView.isHidden = false
            self.tableView.separatorStyle = .none
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.peoples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        
        cell.textLabel?.text = peoples[indexPath.row].name
        cell.detailTextLabel?.text = peoples[indexPath.row].detail
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { (action, view, completeHandler) in
            //删除数据
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let context = appDelegate.persistentContainer.viewContext
                let peopleToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(peopleToDelete)
            
                appDelegate.saveContext()
            }
            completeHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    //MARK: - fetch delegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    //数据发生变化即会调用
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let index = indexPath {
                self.tableView.deleteRows(at: [index], with: .fade)
            }
        case .insert:
            //注意插入的是新行
            if let index = newIndexPath {
                self.tableView.insertRows(at: [index], with: .fade)
            }
        case .update:
            if let index = indexPath {
                self.tableView.reloadRows(at: [index], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchObjects = fetchResultController.fetchedObjects {
            self.peoples = fetchObjects
        }
    }
}

