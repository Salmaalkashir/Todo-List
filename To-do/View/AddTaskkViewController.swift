//
//  AddTaskkViewController.swift
//  To-do
//
//  Created by Salma on 06/04/2023.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore

class AddTaskkViewController: UIViewController {
    
    @IBOutlet weak var Tasknamee: UITextField!
    @IBOutlet weak var TaskDescription: UITextField!
    @IBOutlet weak var TaskPriority: UISegmentedControl!
    @IBOutlet weak var TaskDate: UIDatePicker!
    @IBOutlet weak var TaskState: UISegmentedControl!
    var coreobj : CoreDataViewModel?
    var coredata : CoreDataManager?
    var firestoreobjvm : FireStoreViewModel?
    var err : String?
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreobj = CoreDataViewModel()
        firestoreobjvm = FireStoreViewModel()
        
        Tasknamee.layer.cornerRadius = 15
        Tasknamee.layer.borderWidth = 1.5
        Tasknamee.layer.borderColor = UIColor(named: "gr")?.cgColor
        Tasknamee.borderStyle = .roundedRect
        
        
        TaskDescription.layer.cornerRadius = 15
        TaskDescription.layer.borderWidth = 1.5
        TaskDescription.layer.borderColor = UIColor(named: "gr")?.cgColor
        TaskDescription.borderStyle = .roundedRect
  
        
        
    }
    @IBAction func addbtn(_ sender: Any) {
        if Tasknamee.text == ""
        {
            let alert = UIAlertController(title: "Missing Content!", message: "Please enter title for your task", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true, completion: nil)
        }
        else
        {
            coreobj?.savetocoredata(title: Tasknamee.text ?? "", description: TaskDescription.text ?? "", date: TaskDate.date , priority: TaskPriority.titleForSegment(at:TaskPriority.selectedSegmentIndex) ?? "", state: TaskState.titleForSegment(at: TaskState.selectedSegmentIndex) ?? "" )
            
            firestoreobjvm?.addtasks(namee: Tasknamee.text ?? "", desc: TaskDescription.text ?? "", prio: TaskPriority.titleForSegment(at:TaskPriority.selectedSegmentIndex) ?? "", dateee: "date\(TaskDate.date)", stateee: TaskState.titleForSegment(at: TaskState.selectedSegmentIndex) ?? "" , messegeSender: Auth.auth().currentUser?.email ?? "")
            
            firestoreobjvm?.binderror = {
                self.err = self.firestoreobjvm?.errors
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
}
