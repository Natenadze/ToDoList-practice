//
//  ToDoItemModel.swift
//  ToDoList
//

import Foundation
import RealmSwift


public class LocalDataBaseManager {
    
    static var realm: Realm? {
        
        get {
            
            do {
                let realm = try Realm()
                return realm
            } catch {
                return nil
            }
        }
    }
    
}


class Task: Object {
    
    // We have to give a unique ID to every object
    @objc dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    @objc dynamic var name = ""
    @objc dynamic var details = ""
    @objc dynamic var completionDate = NSDate()
    @objc dynamic var startDate = NSDate()
    @objc dynamic var isComplete = false
    
}


/*
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
     }
 }
 */

