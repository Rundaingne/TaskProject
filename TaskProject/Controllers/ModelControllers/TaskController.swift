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
    
    //MARK: Source of truth
    //This will be the MOC, and will be a computed property
    var tasks: [Task] {
        return fetchTasks()
    }
        //First I need to grab the paylists off the hard drive. Make a request:
    
    //MARK: Mock Data
    
    //MARK: CRUD
    func addTask(taskWithName name: String, notes: String?, due: Date?) {
        guard let notes = notes,
            let due = due else {return}
        Task(name: name, notes: notes, due: due)
        saveToPersistence()
    }
    
    func updateTask(task: Task, name: String, notes: String?, due: Date?) {
        task.name = name
        task.notes = notes
        task.due = due
        saveToPersistence()
    }
    
    func deleteTask(taskToRemove: Task) {
        CoreDataStack.context.delete(taskToRemove)
        saveToPersistence()
    }
    
    //MARK: Other functionality
    
    //MARK: Persistence
    
    func fetchTasks() -> [Task] {
        var request = NSFetchRequest<Task>()
        request = Task.fetchRequest()
        return(try? CoreDataStack.context.fetch(request)) ?? []
    }
    
    func saveToPersistence() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("error saving data. \(error): \(error.localizedDescription)")
        }
    }
    
}
