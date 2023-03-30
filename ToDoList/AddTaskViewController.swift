//
//  AddTaskViewController.swift
//  ToDoList
//


import UIKit

class AddTaskViewController: UIViewController {
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDetailsTextView: UITextView!
    @IBOutlet weak var taskCompletionDatePicker: UIDatePicker!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    // MARK: -  LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskDetailsTextView.layer.borderWidth = 1
        taskDetailsTextView.layer.borderColor = UIColor.lightGray.cgColor
        taskDetailsTextView.layer.cornerRadius = 4
        
    }
    
    // MARK: - Helpers
    
    func reportError(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    //
    func validateTaskDetails() -> (name: String, details: String, completionDate: Date)? {
        
        // Check Name TextField
        guard let taskName = taskNameTextField.text, !taskName.isEmpty else {
            reportError(title: "Invalid Task Name", message: "Task name is required")
            return nil
        }
        
        // Check description text View
        let taskDetails = taskDetailsTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if taskDetails.isEmpty {
            reportError(title: "Invalid Task Details", message: "Task details are required")
            return nil
        }
        
        // Check the Date not to be  past
        let completionDate = taskCompletionDatePicker.date
        if completionDate < Date() {
            reportError(title: "Invalid Date", message: "Date must be in the future")
            return nil
        }
        
        return (name: taskName, details: taskDetails, completionDate: completionDate)
    }
    
    
    
    // MARK: - Actions
    
    @IBAction func addTaskDidTouch(_ sender: Any) {
        
        guard let taskDetails = validateTaskDetails() else { return }
        
        guard let realm = LocalDataBaseManager.realm else {
            reportError(title: "Error", message: "A new task could not be created")
            return
        }
        
        // get newTask ID
        let nextTaskId = (realm.objects(Task.self).max(ofProperty: "id") as Int? ?? 0) + 1
        
        // create Task
        let newTask = Task()
        newTask.id = nextTaskId
        newTask.name = taskDetails.name
        newTask.details = taskDetails.details
        newTask.completionDate = taskDetails.completionDate
        
        // Add to Realm DataBase
        do {
            try realm.write({
                realm.add(newTask)
            })
        } catch let error as NSError {
            print(error.localizedDescription)
            reportError(title: "Error", message: "A new task could not be created")
            return
        }
        
        // Send Notification
        NotificationCenter.default.post(name: NSNotification.Name.init("com.todolistapp.addtask"), object: nil)
        
        dismiss(animated: true)
        
    }
    
}
