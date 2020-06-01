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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("test.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
    }
    
    func saveItem(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        }catch{
            print("Error encoding: \(error)")
        }
    }
    
    func loadItems(){
        let decoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: dataFilePath!){
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print(error)
            }
            
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
                let newItem = Item(name: newNote)
                let indexPath = IndexPath(row: self.itemArray.count, section: 0)
                
                self.itemArray.append(newItem)
                self.saveItem()
                
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                note.text = ""
            }
        }
        
        alertAC.addAction(addNote)
        present(alertAC, animated: true)
    }
}

