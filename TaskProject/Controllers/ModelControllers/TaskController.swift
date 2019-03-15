//
//  TaskController.swift
//  TaskProject
//
//  Created by Brooke Kumpunen on 3/13/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import Foundation
import CoreData

class TaskController {
    
    //MARK: Singleton
    static let shared = TaskController()
    private init() {}
    //MARK: Source of truth
    //This will be the MOC. We can actually just use the fetchedResultsController and the CoreDataStack to store all of our data. Whoa.
    
    //MARK: Mock Data
    
    //MARK: CRUD
    func addTask(taskWithName name: String, notes: String, due: Date) {
        Task(name: name, notes: notes, due: due)
        saveToPersistence()
    }
    
    func updateTask(task: Task, name: String, notes: String, due: Date) {
        task.name = name
        task.notes = notes
        task.due = due
        saveToPersistence()
    }
    
    func deleteTask(taskToRemove: Task) {
        taskToRemove.managedObjectContext?.delete(taskToRemove)
        saveToPersistence()
    }
    
    //MARK: Other functionality
    
    //MARK: Persistence
    
    func saveToPersistence() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("error saving data. \(error): \(error.localizedDescription)")
        }
    }
    
}
