//
//  ViewController.swift
//  core-data-tutorial
//
//  Created by Sawyer Cherry on 11/12/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    
    var people: [NSManagedObject] = []

    @IBOutlet weak var tableView: UITableView!
    @IBAction func pressedAddButton(_ sender: Any) {
        let alert = UIAlertController(title: "New Friend", message: "add the name of your friend.", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Add now!", style: .default) { action in
            guard let textField = alert.textFields?.first, let nameToSave = textField.text else { return }
            
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.dataSource = self
        
        load()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var person = people[indexPath.row]
        
        cell.textLabel?.text = person.value(forKey: "name") as! String
   
        return cell
    }
    
    func save(name: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)!
        
        let person = NSManagedObject(entity: entity, insertInto: context)
        
        person.setValue(name, forKey: "name")
        
        appDelegate.saveContext()
        
        people.append(person)
    }

    
    func load() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequests = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            let results = try context.fetch(fetchRequests)
            self.people = results
        } catch {
            print(error.localizedDescription)
        }
        
        
    }

}


