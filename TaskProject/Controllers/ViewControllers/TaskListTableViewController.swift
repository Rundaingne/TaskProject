//
//  TaskListTableViewController.swift
//  TaskProject
//
//  Created by Brooke Kumpunen on 3/13/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController {
    
    //MARK: -Properties
    let fetchedResultsController: NSFetchedResultsController<Task> = {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        let sorter = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sorter]
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
    }()

    override func viewDidLoad() {
        fetchedResultsController.delegate = self
        super.viewDidLoad()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error fetching data")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskListCell", for: indexPath) as? ButtonTableViewCell
        //Now get the data, then put it into the cell.
        let task = fetchedResultsController.object(at: indexPath)
        cell?.delegate = self
        cell?.task = task
//        cell?.taskNameLabel.text = task.name
        return cell ?? UITableViewCell()
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = fetchedResultsController.object(at: indexPath)
            TaskController.shared.deleteTask(taskToRemove: taskToDelete)
        }
    }
 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskDetail", let indexPath = tableView.indexPathForSelectedRow {
            let destinationVC = segue.destination as? TaskDetailTableViewController
            let selectedTask = fetchedResultsController.object(at: indexPath)
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
            cell.contentView.backgroundColor = UIColor.darkGray
            let onImage = UIImage(imageLiteralResourceName: "Venus")
            cell.button.setImage(onImage, for: .normal)
        } else {
            //Change the background color back to normal, change the image again.
            cell.contentView.backgroundColor = UIColor.white
            let offImage = UIImage(imageLiteralResourceName: "Isaac2")
            cell.button.setImage(offImage, for: .normal)
        }
    }
}

extension TaskListTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else {return}
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else {return}
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else {return}
            tableView.moveRow(at: indexPath, to: newIndexPath)
            tableView.reloadRows(at: [indexPath, newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else {return}
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
