//
//  ToDoItemModel.swift
//  ToDoList
//

import Foundation


struct ToDoItemModel {
    
    var name: String
    var details: String
    var completionDate: Date
    var startDate: Date = Date()
    var isComplete: Bool = false
    
    
    // MARK: - Init
    
    init(name: String, details: String, completionDate: Date) {
        
        self.name = name
        self.details = details
        self.completionDate = completionDate
//        self.isComplete = false
//        self.startDate = Date()
        
    }
}
