//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mark Patrick Perdon on 6/29/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categoriesArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        //          print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoriesArray = try context.fetch(request)
        }catch{
            print(error)
        }
    }
    
    func saveCategory(){
        do{
            try context.save()
        }catch{
            print("Error saving: \(error)")
        }
    }
}

// MARK: - Table view data source
extension CategoryViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoriesArray[indexPath.row].categoryName
        return cell
    }
}

// MARK: - Table View Delegate Methods
extension CategoryViewController{
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction{
        let category = categoriesArray[indexPath.row]
        
        //alert controller for editing category
        var categoryText = UITextField()
        let editCategoryAC = UIAlertController(title: "Edit", message: category.categoryName, preferredStyle: .alert)
        
        editCategoryAC.addTextField { (textfield) in
            textfield.placeholder = category.categoryName
            categoryText = textfield
        }
        
        let editCategoryAction = UIAlertAction(title: "Save", style: .destructive) { (action) in
            if let text = categoryText.text, !text.isEmpty{
                category.setValue(text, forKey: "categoryName")
                self.saveCategory()
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
        }
        
        editCategoryAC.addAction(editCategoryAction)
        editCategoryAC.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        let contextualAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            self.present(editCategoryAC, animated: true)
            completion(true)
        }
        contextualAction.backgroundColor = .systemYellow
        return contextualAction
    }
}

//MARK: - Bar Button Item
extension CategoryViewController{
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let addCategoryAC = UIAlertController(title: "Add Catergory",
                                              message: "Type in a category",
                                              preferredStyle: .alert)
        
        var categoryText = UITextField()
        
        addCategoryAC.addTextField { (textfield) in
            textfield.placeholder = "Groceries, Reminders, etc."
            categoryText = textfield
        }
        
        let addCategoryAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if let text = categoryText.text, !text.isEmpty{
                let newCategory = Category(context: self.context)
                let indexPath = IndexPath(item: self.categoriesArray.count, section: 0)
                
                newCategory.categoryName = text
                self.categoriesArray.append(newCategory)
                self.saveCategory()
                
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                categoryText.text = ""
            }
        }
        
        addCategoryAC.addAction(addCategoryAction)
        present(addCategoryAC, animated: true)
    }
}
