//
//  categoryTableViewController.swift
//  Todey
//
//  Created by Abins Musthafa on 18/02/19.
//  Copyright © 2019 Abins Musthafa. All rights reserved.
//

import UIKit
import CoreData

class categoryTableViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

         loadCategories()
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories[indexPath.row]
            
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var txtForCategory = UITextField()
       let alertController = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        alertController.addTextField { (txtCategory) in
            txtForCategory = txtCategory
            txtCategory.placeholder = "Add Category"
        }
        
        
        let saveAction = UIAlertAction.init(title: "Add Category", style: .default) { (alert) in
            print(txtForCategory.text!)
            
            let newCategory = Category(context: self.context)
            newCategory.name = txtForCategory.text
           self.categories.append(newCategory)
            self.saveCategories()
            
        }
        
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    func loadCategories(){
        
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            
           categories =  try context.fetch(request)
        }
        catch{
            print("Error\(error)")
        }
        tableView.reloadData()
    }
    
    
    func saveCategories(){
        
        
        do {
            try context.save()
        }
        catch{
            print("error\(error)")
            
            
        }
        tableView.reloadData()
    }
    
    
    
    }
    
    
    

    

