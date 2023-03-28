//
//  ToDoListViewController.swift
//  ToDoList
//


import UIKit

protocol ToDoListDelegate: AnyObject {
    
    func update(task: ToDoItemModel, index: Int)
    
}

class ToDoListViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var toDoItems: [ToDoItemModel] = [ToDoItemModel]()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = "To Do List"
        
        let testItem = ToDoItemModel(name: "Running", details: "4km", completionDate: Date())
        toDoItems.append(testItem)
        
    }
    
}

// MARK: - TableView Data Source

extension ToDoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = toDoItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")!
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.isComplete ? "Complete" : "Incomplete"
        return cell
    }
    
    
}

// MARK: - TableView Delegate

extension ToDoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = toDoItems[indexPath.row]
        
        let toDoTuple = (indexPath.row, selectedItem) // to pass index with item itself
        
        performSegue(withIdentifier: "TaskDetailsSegue", sender: toDoTuple)
    }
    
}


extension ToDoListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TaskDetailsSegue" {
            guard let destinationVC = segue.destination as? ToDoDetailsViewController else { return }
            guard let tupleItem = sender as? (Int, ToDoItemModel) else { return }
            
            destinationVC.toDoIndex = tupleItem.0  // pass index
            destinationVC.toDoItem = tupleItem.1   // pass toDo item
            destinationVC.delegate = self
        }
    }
}


extension ToDoListViewController: ToDoListDelegate {
    
    func update(task: ToDoItemModel, index: Int) {
        
        toDoItems[index] = task
        
        tableView.reloadData()
        
    }
    
}
