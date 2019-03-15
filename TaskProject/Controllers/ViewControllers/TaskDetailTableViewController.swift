//
//  TaskDetailTableViewController.swift
//  TaskProject
//
//  Created by Brooke Kumpunen on 3/13/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController {
    
    //Landing pads and other cool stuff!
    var selectedTask: Task? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    //MARK: Outlets
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var notesTextField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    //MARK: Other Functions
    func updateTask() {
        guard let name = taskNameTextField.text,
          let note = notesTextField.text else {return}
        if let selectedTask = selectedTask {
            TaskController.shared.updateTask(task: selectedTask, name: name, notes: note, due: dueDatePicker.date)
        } else {
            TaskController.shared.addTask(taskWithName: name, notes: note, due: dueDatePicker.date)
        }
    }
    
    func updateViews() {
        guard let selectedTask = selectedTask,
         let date = selectedTask.due else {return}
        taskNameTextField.text = selectedTask.name
        notesTextField.text = selectedTask.notes
        dueDatePicker.date = date
    }
    
    //MARK: Actions
    @IBAction func saveTaskButtonTapped(_ sender: UIBarButtonItem) {
        updateTask()
        taskNameTextField.text = ""
        notesTextField.text = ""
        navigationController?.popViewController(animated: true)
    }
}
