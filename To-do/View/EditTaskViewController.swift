//
//  EditTaskViewController.swift
//  To-do
//
//  Created by Salma on 06/04/2023.
//

import UIKit
import Reachability


class EditTaskViewController: UIViewController {
    @IBOutlet weak var taskname: UITextField!
    @IBOutlet weak var taskdescription: UITextField!
    @IBOutlet weak var taskstate: UISegmentedControl!
    @IBOutlet weak var taskpriority: UISegmentedControl!
    @IBOutlet weak var taskdate: UIDatePicker!
    
    var tasktitle : String?
    var taskdescriptionn : String?
    var taskpriorityy : String?
    var taskdatee : Date?
    var taskstatee : String?
    var id : UUID?
    var indexpath : String?
    
    var coreobj : CoreDataViewModel?
    var firestoreobj : FireStoreViewModel?
    var firestoretasks : [Taskk] = []
    var reachability : Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreobj = CoreDataViewModel()
        firestoreobj = FireStoreViewModel()
        taskname.text = tasktitle
        taskdescription.text = taskdescriptionn
        taskdate.date = taskdatee ?? Date()
        reachability = Reachability.forInternetConnection()
        
        taskname.layer.cornerRadius = 15
        taskname.layer.borderColor = UIColor(named: "gr")?.cgColor
        taskname.layer.borderWidth = 1.5
        taskname.borderStyle = .roundedRect
        
        taskdescription.layer.cornerRadius = 15
        taskdescription.layer.borderColor = UIColor(named: "gr")?.cgColor
        taskdescription.layer.borderWidth = 1.5
        taskdescription.borderStyle = .roundedRect
        
        loaddata()
    }
    
    @IBAction func editbtn(_ sender: Any) {
        if((self.reachability!.isReachable()))
        {
            firestoreobj?.edittaskkk(namee: taskname.text ?? "", desc: taskdescription.text ?? "", prio: taskpriority.titleForSegment(at: taskpriority.selectedSegmentIndex) ?? "", stateee: taskstate.titleForSegment(at: taskstate.selectedSegmentIndex) ?? "", dateee: "date\(taskdate.date)", id: indexpath ?? "" )
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            coreobj?.edittask(title: taskname.text ?? "", description: taskdescription.text ?? "", date: taskdate.date, priority: taskpriority.titleForSegment(at: taskpriority.selectedSegmentIndex) ?? "", state: taskstate.titleForSegment(at: taskstate.selectedSegmentIndex) ?? "", uuid: id ?? UUID())
            self.navigationController?.popViewController(animated: true)
            
        }
        
    }

    func loaddata()
    {
        switch taskstatee
        {
        case "ToDo":
            taskstate.selectedSegmentIndex = 0
        case "Inprogress":
            taskstate.selectedSegmentIndex = 1
        case "Done":
            taskstate.selectedSegmentIndex = 2
        default:
            break
        }
       
        switch taskpriorityy
        {
        case "High":
            taskpriority.selectedSegmentIndex = 0
        case "Medium":
            taskpriority.selectedSegmentIndex = 1
        case "Low":
            taskpriority.selectedSegmentIndex = 2
        default:
            break
        }
    }
}
