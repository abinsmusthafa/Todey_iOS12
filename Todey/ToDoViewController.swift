//
//  ViewController.swift
//  Todey
//
//  Created by Abins Musthafa on 16/02/19.
//  Copyright © 2019 Abins Musthafa. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController:UITableViewController {
    let context =
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
        var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
           loadItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    
  
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for:indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        cell.accessoryType = item.done ? .checkmark : .none
        
      
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
        
       
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
       // itemArray[indexPath.row].done = !itemArray[indexPath.row].done
       
        
        saveItems()
       
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //MARK - add item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "ADD NEW TODOY ITEM", message: "", preferredStyle: .alert)
        
         // Add text field to alertcontroller
        
        alert.addTextField { (alertTextField) in
            textField.placeholder = "Enter New Item"
            textField = alertTextField
        }
        
        
        let action = UIAlertAction(title: "ADD ITEM", style: .default) { (action) in
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
          self.saveItems()
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
        
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems(){
       
        
        do {
            try context.save()
        }
        catch{
            print("error\(error)")
       
            
        }
         self.tableView.reloadData()
    }
    
    func loadItem(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate?=nil){
        
       let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let addtionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        
       
        
            do{
               itemArray =  try context.fetch(request)
            }
            catch{
               print("Error\(error)")
            }
        tableView.reloadData()
        }
    
    
    
    
    
    
    }//end of class

extension ToDoViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        
        let sortDescriptor =
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItem(with: request,predicate: predicate)
//        do{
//            itemArray =  try context.fetch(request)
//        }
//        catch{
//            print("Error\(error)")
//        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItem()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
} //end of todoviewcontroller extension
    


