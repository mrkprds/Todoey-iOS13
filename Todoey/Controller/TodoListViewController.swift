//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
//                    [Item(name: "Item1"),
//                     Item(name: "Item2"),
//                     Item(name: "Item3"),
//                     Item(name: "a"),
//                     Item(name: "b"),
//                     Item(name: "c"),
//                     Item(name: "t"),
//                     Item(name: "h"),
//                     Item(name: "e"),
//                     Item(name: "q"),
//                     Item(name: "u"),
//                     Item(name: "i"),
//                     Item(name: "c"),
//                     Item(name: "k"),
//                     Item(name: "b"),
//                     Item(name: "r"),
//                     Item(name: "o"),
//                     Item(name: "w"),
//                     Item(name: "n"),
//                     Item(name: "f"),
//                     Item(name: "o"),
//                     Item(name: "x"),
//                     Item(name: "j"),
//                     Item(name: "u"),
//                     Item(name: "m"),
//                     Item(name: "p"),
//                     Item(name: "s"),
//                     Item(name: "o"),
//                     Item(name: "v"),
//                     Item(name: "e"),
//                     Item(name: "r"),
//                     Item(name: "t"),
//                     Item(name: "h"),
//                     Item(name: "e"),
//                     Item(name: "l"),
//                     Item(name: "a"),
//                     Item(name: "z"),
//                     Item(name: "y"),
//                     Item(name: "d"),
//                     Item(name: "o"),
//                     Item(name: "g")]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let itemsArray = defaults.array(forKey: Const.itemsArrayKey) as? [Item]{
            self.itemArray = itemsArray
        }
    }
}

//MARK: Table View Datasource Methods
extension TodoListViewController{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.todoCellID, for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.accessoryType = item.isChecked == true ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
}

//MARK: Table View Delegate Methods
extension TodoListViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .fade)
        
    }
}

//MARK: Bar Button Action
extension TodoListViewController{
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var note    = UITextField()
        let alertAC = UIAlertController(title: "Add New Item",
                                        message: "",
                                        preferredStyle: .alert)
        
        alertAC.addTextField { (textField) in
            note = textField
            textField.placeholder = "Create new item"
        }
        
        let addNote = UIAlertAction(title: "Add Item", style: .default){ action in
            if let newNote = note.text, !newNote.isEmpty{
                let indexPath = IndexPath(row: self.itemArray.count, section: 0)
                let item = Item(name: newNote)
                
                self.itemArray.append(item)
                //                let encodedData = NSKeyedArchiver
                
                self.defaults.set(self.itemArray, forKey: Const.itemsArrayKey )
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                note.text = ""
            }
        }
        
        alertAC.addAction(addNote)
        present(alertAC, animated: true)
    }
}

