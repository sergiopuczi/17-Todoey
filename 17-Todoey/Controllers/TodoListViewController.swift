//
//  ViewController.swift
//  17-Todoey
//
//  Created by Sergio Puczi on 12/04/18.
//  Copyright © 2018 Sergio Puczi. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let defaults = UserDefaults.standard

    var itemArray = [Item]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Milk"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Bread"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Sugar"
        itemArray.append(newItem3)
        
        //if Persistent Data Local Storage is not empty
        if let item = defaults.array(forKey: "TodoListArray") as? [Item] {

            //itemArray contains the data of Persistent Data Local Storage (TodoListArray)
            itemArray = item
        }
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }
//        else {
//            cell.accessoryType = .none
//        }
        //Shorter form: value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Quando seleziono una cella non rimane sempre selezionata, ma si deseleziona subito dopo
        tableView.deselectRow(at: indexPath, animated: true)
        
        //sets the "done" property to it's opposite
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //call Tableview Datasource Methods again
        tableView.reloadData()
        
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user click the "Add Item" button on our UIAlert
            let newItem = Item()
            newItem.title = textField.text!

            self.itemArray.append(newItem)
            
            //save data on "TodoListArray" Persistent Data Local Storage
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    

}

