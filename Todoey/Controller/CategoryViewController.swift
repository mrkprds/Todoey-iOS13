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
    override func viewDidLoad() {
        super.viewDidLoad()
//          print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        return cell
    }
    
    // MARK: - Table View Delegate Methods
}
