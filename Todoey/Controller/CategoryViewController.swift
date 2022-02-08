//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ivan Romero on 01/02/2022.
//  Copyright © 2022 Seven Software. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       loadItems()
        
        navigationController?.navigationBar.backgroundColor = UIColor.blue
    }
    
    
    //MARK: - Table View Dataosurce Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryItemCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        
        return cell
        
    }
    
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
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
    
}
