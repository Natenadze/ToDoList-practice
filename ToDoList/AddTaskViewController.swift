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

    
    // MARK: - Actions
    
    @IBAction func addTaskDidTouch(_ sender: Any) {
        
        let taskDetails: String = taskDetailsTextView.text
        let completionDate: Date = taskCompletionDatePicker.date
        
        guard let taskName = taskNameTextField.text, !taskName.isEmpty else {
            reportError(title: "Invalid Task Name", message: "Task name is required")
            return
        }
        
        if taskDetailsTextView.text.isEmpty {
            reportError(title: "Invalid Task Details", message: "Task details are required")
            return
        }
        
        if completionDate < Date() {
            reportError(title: "Invalid Date", message: "Date must be in the future")
            return
        }
       
        guard let realm = LocalDataBaseManager.realm else {
            reportError(title: "Error", message: "A new task could not be created")
            return
        }
        
        // what is max number for id and create next one by adding 1
        let nextTaskId = (realm.objects(Task.self).max(ofProperty: "id") as Int? ?? 0) + 1
        
        // create new Task
        let newTask = Task()
        newTask.id = nextTaskId
        newTask.name = taskName
        newTask.details = taskDetails
        newTask.completionDate = completionDate as NSDate
        newTask.isComplete = false   // do i need this??
        
        // try to save newTask or show error (ex: no enough space in phone)
        do {
            try realm.write({
                realm.add(newTask)
            })
        } catch let error as NSError {
            print(error.localizedDescription)
            reportError(title: "Error", message: "A new task could not be created")
            return
        }
        
        NotificationCenter.default.post(name: NSNotification.Name.init("com.todolistapp.addtask"), object: nil)

        dismiss(animated: true)
    }
    
    
    
}
