//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Item1", "Item2", "Item3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

//MARK: Table View Datasource Methods
extension TodoListViewController{
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Const.todoCellID, for: indexPath)
    cell.textLabel?.text = itemArray[indexPath.row]
       return cell
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return itemArray.count
   }
}

//MARK: Table View Delegate Methods
extension TodoListViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
//        if itemArray[indexPath.row].isChecked == false{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//            itemArray[indexPath.row].isChecked = true
////            tableView.reloadData()
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//            itemArray[indexPath.row].isChecked = false
////            tableView.reloadData()
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

