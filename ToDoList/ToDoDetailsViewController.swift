//
//  ToDoDetailsViewController.swift
//  ToDoList
//


import UIKit




class ToDoDetailsViewController: UIViewController {
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskDetailsTextView: UITextView!
    @IBOutlet weak var taskCompletionButton: UIButton!
    @IBOutlet weak var taskCompletionDate: UILabel!
    
    var toDoItem: Task!
    var toDoIndex: Int!
    weak var delegate: ToDoListDelegate?
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateView()
        formatData()
    }
    
    // MARK: - Helpers
    
    func populateView() {
        
        taskTitleLabel.text = toDoItem.name
        taskDetailsTextView.text = toDoItem.details
        
        if toDoItem.isComplete {
            disableButton()
        }
    }
    
    func formatData() {
        let formatter = DateFormatter()
        // MM = month in numbers
        // MMM = month in String
        formatter.dateFormat = "MMM dd, yyyy - hh:mm"
        let taskDate = formatter.string(from: toDoItem.completionDate as Date)
        taskCompletionDate.text = taskDate
    }
    
    func disableButton() {
        
        taskCompletionButton.backgroundColor = UIColor.gray
        taskCompletionButton.isEnabled = false
    }
    
    
    // MARK: - IBAction
    
    @IBAction func taskDidComplete(_ sender: Any) {
        
        guard let realm = LocalDataBaseManager.realm else { return }
        
        do {
            try realm.write({
                toDoItem.isComplete = true
            })
        } catch let error as NSError {
            print(error.localizedDescription)
            return
        }
        
        delegate?.update()
        disableButton()
    }
    
}





