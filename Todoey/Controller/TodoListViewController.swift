//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("test.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    func saveItem(){
        do{
            try context.save()
        }catch{
            print("Error saving: \(error)")
        }
    }
    
    func loadItems(){
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do{
            itemArray = try context.fetch(request)
        }catch{
            print(error)
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
        saveItem()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit   = editAction(at: indexPath)
//        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction{
        let item = itemArray[indexPath.row]
        
        //alert controller for editing note
        var note = UITextField()
        let editNoteAC = UIAlertController(title: "Edit Note", message: "", preferredStyle: .alert)
        editNoteAC.addTextField { (textField) in
            note = textField
            textField.placeholder = "\(item.name!)"
        }
        let saveEditNote = UIAlertAction(title: "Save", style: .destructive) { (action) in
            if let editedNote = note.text, !editedNote.isEmpty{
                item.setValue(editedNote, forKey: "name")
                self.saveItem()
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
        editNoteAC.addAction(saveEditNote)
        editNoteAC.addAction(UIAlertAction(title: "Cancel", style: .default))

        //when edit is pressed on swipeaction it will show alert controller for editing note
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            self.present(editNoteAC, animated: true)
        }
        
        return action
    }
//    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
//
//    }
}

//MARK: Bar Button Action
extension TodoListViewController{
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var note    = UITextField()
        let newNoteAC = UIAlertController(title: "Add New Item",
                                        message: "",
                                        preferredStyle: .alert)
        
        newNoteAC.addTextField { (textField) in
            note = textField
            textField.placeholder = "Create new item"
        }
        
        let addNote = UIAlertAction(title: "Add Item", style: .default){ action in
            if let newNote = note.text, !newNote.isEmpty{
                let newItem = Item(context: self.context)
                let indexPath = IndexPath(row: self.itemArray.count, section: 0)
                
                newItem.name = newNote
                newItem.isChecked = false
                self.itemArray.append(newItem)
                self.saveItem()
                
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                note.text = ""
            }
        }
        
        newNoteAC.addAction(addNote)
        present(newNoteAC, animated: true)
    }
}

