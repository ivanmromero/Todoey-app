//
//  TodoListViewController.swift
//  Todoey
//
//  Created by Ivan Romero on 01/02/2022.
//  Copyright © 2022 Seven Software. All rights reserved.
//

import UIKit
import  RealmSwift

class TodoListViewController: UITableViewController{
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //                if let item = defaults.array(forKey: "TodoListArray") as? [Items]{
        //                    itemArray = item
        //                }
        navigationController?.navigationBar.backgroundColor = UIColor.blue
    }
    
    
    //MARK: Tableview Datasource Methods
    
    //this functions tells the numbers of rows are in controller view
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            //ternary state
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No items added yet"
        }
        
        
        
        return cell
        
    }
    
    
    //MARK: Tableview Delegate Methods
    
    //this function acting when pressed items in controller view and UPDATE data base on coredata
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write{
                    item.done = !item.done
                }
            } catch{
                print("Error with update checkmark will select a row \(error)")
            }
        }
        
        
        
        //print(itemArray[indexPath.row])
        //the next if question tells that if checkmark is true accessorytype or is none and else accesorytype is checkmark
        
        //        itemArray.remove(at: indexPath.row)
        //        context.delete(itemArray[indexPath.row])
        
        //        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        //
        //        saveItems()
        
        // quit the gray mark of selected item
        tableView.deselectRow(at: indexPath, animated: true)
        self.tableView.reloadData()
        
    }
    
    
    //MARK: Add new items
    // This Function CREATE a new data on data base
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey element", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                        newItem.dateCreated = Date()
                    }
                } catch{
                    print("Error saving new Items \(error)")
                }
                
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    // this function save data base in core data
    
    
    
    //    this function READ data base from core data
    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        
        //        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        //
        //        if let additionalPredicate = predicate {
        //            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        //        } else {
        //            request.predicate = categoryPredicate
        //        }
        //
        //
        //        do {
        //            itemArray = try context.fetch(request)
        //
        //        } catch {
        //            print("Error fetching data from context\(error)")
        //        }
        tableView.reloadData()
    }
    
}

//MARK: Search bar methods

extension TodoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

//        let request: NSFetchRequest<Items> = Items.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        // sort request
//
//        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
        
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

