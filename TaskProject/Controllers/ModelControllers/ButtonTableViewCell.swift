//
//  ButtonTableViewCell.swift
//  TaskProject
//
//  Created by Brooke Kumpunen on 3/13/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate: class {
    func buttonCellButtonTapped(cell: ButtonTableViewCell)
}

class ButtonTableViewCell: UITableViewCell {
    
    //Landing pads and delegate patterns
    weak var delegate: ButtonTableViewCellDelegate?
    //Anytime we pass information from the delegate(TaskListTableViewController) to the child(ButtonTableViewCell), we need to have somewhere for that data to land. That data lands in the task variable, and the cell can then use it to update its views.
    var task: Task? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: Outlets
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var targetDateLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.setImage(UIImage(imageLiteralResourceName: "Isaac2"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: Functions
    func updateViews() {
        guard let task = task else {return}
        //Update all the labels. I have a nameLabel, a dateLabel, and an image view. Whenever I add the date formatting, the function ceases to work. I will need to redo that part; I think it is related to having my datePicker not embedded in a textField. Finally, I need to get the UIImage to work and change when I tap it, but that will happen in the buttonCellButtonTapped function.
        taskNameLabel.text = task.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        guard let due = task.due else {return}
        let dueDate = dateFormatter.string(from: due)
        targetDateLabel.text = dueDate
    }
    
    //MARK: Actions
    @IBAction func taskCompleteButtonTapped(_ sender: UIButton) {
        delegate?.buttonCellButtonTapped(cell: self)
        //When I tap this button, the image needs to change, and the cell needs to grey out.
    }
    
    
}
