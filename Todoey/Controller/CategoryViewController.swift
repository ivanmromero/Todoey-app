//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ivan Romero on 01/02/2022.
//  Copyright © 2022 Seven Software. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import SwiftUI

class CategoryViewController: SwipeTableViewController {
    
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
        tableView.rowHeight = 80.0
        
        tableView.separatorStyle = .none
        
        navigationController?.navigationBar.backgroundColor = UIColor.blue
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        
        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
        
        if let navBarColour = UIColor(hexString: "1D9BF6"){
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
        }
        
    }
    
    
    //MARK: - Table View Dataosurce Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let category = categories?[indexPath.row] {
            
            cell.textLabel?.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.color) else {fatalError()}
            
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
            
        }
        
        return cell
    }
    
    
    //MARK: - Table View Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
    //MARK: - Data Manipulation Methods
    //MARK: Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newItem = Category()
            newItem.name = textField.text!
            newItem.color = UIColor.randomFlat().hexValue()
            self.save(category: newItem)
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Methods
    
    
    func save (category: Category){
        do{
            try realm.write{
                realm.add(category)
            }
        } catch{
            print("Error saving context in categories \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems (){
        categories = realm.objects(Category.self)
        //        do{
        //            categorysArray = try context.fetch(request)
        //        } catch{
        //            print("Error with load data in categories:\(error)")
        //        }
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
}



