//
//  ToDoListViewController.swift
//  ToDoList
//


import UIKit
import RealmSwift

protocol ToDoListDelegate: AnyObject {
    
    func update()
    
}

class ToDoListViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var toDoItems: Results<Task>? {
        get {
            guard let realm = LocalDataBaseManager.realm else { return nil}
            return realm.objects(Task.self).sorted(byKeyPath: "completionDate", ascending: true)
        }
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = "To Do List"
        
        
        configureNavBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(addNewTask), name: NSNotification.Name.init("com.todolistapp.addtask"), object: nil)
        
    }
    
    deinit {
        print("Deinit")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("com.todolistapp.addtask"), object: nil)
    }
    
    
    
    // MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TaskDetailsSegue" {
            guard let destinationVC = segue.destination as? ToDoDetailsViewController else { return }
            guard let tupleItem = sender as? (Int, Task) else { return }
            
            destinationVC.toDoIndex = tupleItem.0  // pass index
            destinationVC.toDoItem = tupleItem.1   // pass toDo item
            destinationVC.delegate = self
        }
    }
    
}

// MARK: - TableView Data Source

extension ToDoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toDoItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = toDoItems![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")!
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.isComplete ? "Complete" : "Incomplete"
        return cell
    }
    
    
    // Delete action on swipe or while editing
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            
            guard let realm = LocalDataBaseManager.realm else { return }
            
            // Delete data
            do {
                try realm.write({
                    realm.delete(self.toDoItems![indexPath.row])
                })
            } catch let error as NSError{
                print(error.localizedDescription)
                return
            }
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

// MARK: - TableView Delegate

extension ToDoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = toDoItems![indexPath.row]
        let toDoTuple = (indexPath.row, selectedItem) // to pass index with item itself
        performSegue(withIdentifier: "TaskDetailsSegue", sender: toDoTuple)
    }
    
}


// MARK: - ToDoListDelegate

extension ToDoListViewController: ToDoListDelegate {
    
    func update() {
        
        
        tableView.reloadData()
    }
    
    func configureNavBar() {
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddButton))
        navigationItem.leftBarButtonItem = addButton
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEditButton))
        navigationItem.rightBarButtonItem = editButton
    }
    
}


// MARK: - Selectors

extension ToDoListViewController {
    
    //
    @objc func handleAddButton() {
        performSegue(withIdentifier: "AddTaskSegue", sender: nil)
    }
    
    //
    @objc func handleEditButton() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        // navItem rightBarButton changes between edit/done
        if tableView.isEditing {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleEditButton))
        } else {
            let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEditButton))
            navigationItem.rightBarButtonItem = editButton
        }
    }
    
    //
    @objc func addNewTask() {
        tableView.reloadData()
    }
    
}
