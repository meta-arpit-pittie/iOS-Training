//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Metacube on 06/12/16.
//  Copyright © 2016 Metacube. All rights reserved.
//

import UIKit
import CoreData

class MealTableViewController: UITableViewController {
    
    var meals = [Meal]()
    let cellIdentifier = "MealTableViewCell"
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        setupCoreData()
        // Load any saved meals, otherwise load sample data.
        let result = load()
        for object in result! {
            let mealName = object.value(forKey: "name") as! String
            let mealRating = object.value(forKey: "rating") as! Int
            let mealPhoto = UIImage(data: object.value(forKey: "image") as! Data)
            
            meals.append(Meal(name: mealName, photo: mealPhoto, rating: mealRating)!)
        }
    }
    
    func setupCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        self.appDelegate = appDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MealTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]

        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating

        return cell
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                edit(old: meals[selectedIndexPath.row], to: meal)
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal.
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
                save(meal: meal)
            }
        }
    }
 

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            delete(meal: meals[indexPath.row])
            
            meals.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let mealDetailViewController = segue.destination as! MealViewController
            
            // Get the cell that generated this segue.
            if let selectedMealCell = sender as? MealTableViewCell {
                let indexPath = tableView.indexPath(for: selectedMealCell)
                let selectedMeal = meals[indexPath!.row]
                
                mealDetailViewController.meal = selectedMeal
            }
        }
        else if segue.identifier == "addItem" {
            print("Adding new Meal")
        }
    }
    
    // MARK: Core Data

    func save(meal: Meal) {
        let entity = NSEntityDescription.entity(forEntityName: "Meals", in: managedContext)
        let mealEntity = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        mealEntity.setValue(meal.name, forKey: "name")
        mealEntity.setValue(meal.rating, forKey: "rating")
        mealEntity.setValue(NSData(data: UIImageJPEGRepresentation(meal.photo!, 1.0)!), forKey: "image")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func load() -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Meals")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            return result
        } catch let error as NSError {
            print("Could not load \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func delete(meal: Meal) {
        let result = load()
        for object in result! {
            let mealName = object.value(forKey: "name") as! String
            let mealRating = object.value(forKey: "rating") as! Int
            
            if meal.name == mealName && meal.rating == mealRating {
                managedContext.delete(object)
            }
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not delete \(error), \(error.userInfo)")
        }
    }
    
    func edit(old meal:Meal, to newMeal: Meal) {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Meals")
        let predicateName = NSPredicate(format: "name == %@", meal.name)
        let predicateRating = NSPredicate(format: "rating == \(meal.rating)")
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateName, predicateRating])
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count != 0 {
                result[0].setValue(newMeal.name, forKey: "name")
                result[0].setValue(newMeal.rating, forKey: "rating")
                result[0].setValue(NSData(data: UIImageJPEGRepresentation(newMeal.photo!, 1.0)!), forKey: "image")
                
                print("Edit successful")
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Could not edit\(error), \(error.userInfo)")
        }
    }
    
}
