//
//  ViewController.swift
//  17-Todoey
//
//  Created by Sergio Puczi on 12/04/18.
//  Copyright © 2018 Sergio Puczi. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            //Loading data
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
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
//      Shorter form: value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        // Quando seleziono una cella non rimane sempre selezionata, ma si deseleziona subito dopo
        tableView.deselectRow(at: indexPath, animated: true)
        
        //sets the "done" property to it's opposite
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user click the "Add Item" button on our UIAlert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory

            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Model Manipulation Methods
    
    //Saving data
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        
        //call Tableview Datasource Methods again
        tableView.reloadData()
    }
    
    //Loading data
    
    //Se la request non viene passata come parametro, la funzione assume come default Item.fetchRequest()
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            try itemArray = context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    
}


//MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        //Le stringhe sono case-sensitive e democratic-sensitive, ovvero se al posto di "ciao" scrivo "ciào"
        //sono due stringhe diverse. Facendo CONTAINS[cd] lo faccio diventare insensitive a queste cose
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //Ordiniamo i risultati in base al titolo in ordine alfabetico
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
        tableView.reloadData()
        
    }
    
    //Quando clicco il pulsante "X" per eliminare tutto ciò che ho scritto nella search bar, voglio che
    //ricompaia tutto quello che c'era prima e che esco dalla search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            //DispatchQueue.main.async serve per eseguire l'operazione che c'è sotto in background
            DispatchQueue.main.async {
                //Dice alla search bar che non è più lui quello attivo -> lo disattivo
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}

