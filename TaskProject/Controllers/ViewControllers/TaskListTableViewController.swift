//
//  TaskListTableViewController.swift
//  TaskProject
//
//  Created by Brooke Kumpunen on 3/13/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import UIKit

class TaskListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskController.shared.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskListCell", for: indexPath) as? ButtonTableViewCell
        //Now get the data, then put it into the cell.
        let task = TaskController.shared.tasks[indexPath.row]
        cell?.delegate = self
        cell?.task = task
//        cell?.taskNameLabel.text = task.name
        return cell ?? UITableViewCell()
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = TaskController.shared.tasks[indexPath.row]
            TaskController.shared.deleteTask(taskToRemove: taskToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskDetail", let indexPath = tableView.indexPathForSelectedRow {
            let destinationVC = segue.destination as? TaskDetailTableViewController
            let selectedTask = TaskController.shared.tasks[indexPath.row]
            destinationVC?.selectedTask = selectedTask
        }
    }
}
extension TaskListTableViewController: ButtonTableViewCellDelegate {
    func buttonCellButtonTapped(cell: ButtonTableViewCell) {
        guard let task = cell.task else {return}
        //Alright if I have a task, I need to decide what happens when I tap the buttonCellButton. Hmmmm...
        task.isComplete = !task.isComplete
        if task.isComplete {
            //Change the image, grey the cell.
            cell.contentView.backgroundColor = .gray
        } else {
            //Change the background color back to normal, change the image again.
            cell.contentView.backgroundColor = UIColor.white
        }
        tableView.reloadData()
    }
}
