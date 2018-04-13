//
//  ViewController.swift
//  17-Todoey
//
//  Created by Sergio Puczi on 12/04/18.
//  Copyright © 2018 Sergio Puczi. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Pippo", "Pluto", "Paperino"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        // Quando seleziono una cella non rimane sempre selezionata, ma si deseleziona subito dopo
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Se c'è già la spunta (checkmark) e seleziono di nuovo la cella -> toglila
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            // Altrimenti -> mettila
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
    }
    
    

}

