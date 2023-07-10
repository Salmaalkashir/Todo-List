//
//  ToDoTableViewCell.swift
//  To-do
//
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var calendar: UIImageView!
    @IBOutlet weak var datetask: UIDatePicker!
    @IBOutlet weak var viewww: UIView!
    {
        didSet
        {
            viewww.layer.cornerRadius = 20
            viewww.backgroundColor = .white
            viewww.layer.shadowOffset = CGSize(width: 5, height: 5)
            viewww.layer.shadowRadius = 5
            viewww.layer.shadowOpacity = 0.5
        }
    }
    @IBOutlet weak var priority: UIImageView!
    @IBOutlet weak var taskname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
