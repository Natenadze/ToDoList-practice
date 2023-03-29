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
       
        let toDoItem = ToDoItemModel(name: taskName, details: taskDetails, completionDate: completionDate)
        // first way to pass data with object
        NotificationCenter.default.post(name: NSNotification.Name.init("com.todolistapp.addtask"), object: toDoItem)
        
        // second way with user info, ( to include some additional info )
        let toDoDict = ["Task": toDoItem]
//        NotificationCenter.default.post(name: NSNotification.Name.init("com.todolistapp.addtask"), object: nil, userInfo: toDoDict)
        
        dismiss(animated: true)
    }
    
    
    
}
