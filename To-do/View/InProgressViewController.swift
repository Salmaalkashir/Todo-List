//
//  InProgressViewController.swift
//  To-do
//
//  Created by Salma on 04/04/2023.
//

import UIKit
import CoreData
import FirebaseCore
import FirebaseFirestore
import Reachability
import FirebaseAuth

class InProgressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ProgressTable: UITableView!
    @IBOutlet weak var searchbarr: UISearchBar!
    
    var coreobjvm : CoreDataViewModel?
    var inprogresstask : [NSManagedObject]?
    var searcharray : [NSManagedObject]?
    var searchfire : [Taskk]?
    let db = Firestore.firestore()
    var firestoreinprogresstasks : [Taskk] = []
    var reachability : Reachability?
    var firestoreobjvm : FireStoreViewModel?
    
    var tasktitle : String?
    var taskdescriptionn : String?
    var taskpriorityy : String?
    var taskdatee : Date?
    var taskstatee : String?
    var id : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ToDoTableViewCell", bundle: nil)
        ProgressTable.register(nib, forCellReuseIdentifier: "todocell")
        
        ProgressTable.delegate = self
        ProgressTable.dataSource = self
        
        searchbarr.delegate = self
        coreobjvm = CoreDataViewModel()
        reachability = Reachability.forInternetConnection()
        firestoreobjvm = FireStoreViewModel()
        firestoreobjvm?.gettasks(state: "Inprogress")
        firestoreobjvm?.bindingretrievedtaskstocontrollers = {
            DispatchQueue.main.async {
                self.firestoreinprogresstasks = self.firestoreobjvm?.retrievedtasks ?? []
                self.searchfire = self.firestoreinprogresstasks
                self.ProgressTable.reloadData()
            }
        }
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        inprogresstask = coreobjvm?.fetchdata(state: "Inprogress", user: UserDefaults.standard.string(forKey: "useremail") ?? "")
        searcharray = inprogresstask
        searchfire = firestoreinprogresstasks
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if((reachability!.isReachable()))
        {
            return searchfire?.count ?? 0
        }
        else
        {
            return searcharray?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todocell", for: indexPath) as! ToDoTableViewCell
        if((reachability!.isReachable()))
        {
            cell.taskname.text = searchfire?[indexPath.row].taskname
            switch searchfire?[indexPath.row].taskpriority
            {
            case "High" :
                cell.priority.image = UIImage(named: "Red")
            case "Medium" :
                cell.priority.image = UIImage(named: "Yellow")
            case "Low" :
                cell.priority.image = UIImage(named: "Green")
            default:
                break
            }
        }
        else
        {
            cell.taskname.text = searcharray?[indexPath.row].value(forKey: "name") as? String
            switch searcharray?[indexPath.row].value(forKey: "priority") as! String
            {
            case "High" :
                cell.priority.image = UIImage(named: "Red")
            case "Medium" :
                cell.priority.image = UIImage(named: "Yellow")
            case "Low" :
                cell.priority.image = UIImage(named: "Green")
            default:
                break
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
    
        let alert = UIAlertController(title: "Delete Task", message: "Are you sure you want to delete this task?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            if((self.reachability!.isReachable()))
            {
                self.firestoreobjvm?.deletetasks(id: (self.searchfire?[indexPath.row].id) as? String ?? "")
                self.ProgressTable.reloadData()
            }
            else
            {
                self.coreobjvm?.deletetaskk(uuid: self.searcharray?[indexPath.row].value(forKey: "id") as! UUID)
                self.searcharray = self.coreobjvm?.fetchdata(state: "Inprogress", user: UserDefaults.standard.string(forKey: "useremail") ?? "")
                
                self.ProgressTable.reloadData()
            }


        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        present(alert, animated: true , completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if((reachability!.isReachable()))
        {
            let fireobjedit = self.storyboard?.instantiateViewController(withIdentifier: "edittask") as! EditTaskViewController
            
            fireobjedit.tasktitle = firestoreinprogresstasks[indexPath.row].taskname
            fireobjedit.taskdescriptionn = firestoreinprogresstasks[indexPath.row].taskdescription
            fireobjedit.taskpriorityy = firestoreinprogresstasks[indexPath.row].taskpriority
            fireobjedit.taskdatee = firestoreinprogresstasks[indexPath.row].taskdate
            fireobjedit.taskstatee = firestoreinprogresstasks[indexPath.row].taskstate
            fireobjedit.indexpath = firestoreinprogresstasks[indexPath.row].id 
            self.navigationController?.pushViewController(fireobjedit, animated: true)
        }
        else
        {
            let inprogressobj : EditTaskViewController = self.storyboard?.instantiateViewController(withIdentifier: "edittask") as! EditTaskViewController
            
            inprogressobj.tasktitle = inprogresstask?[indexPath.row].value(forKey: "name") as? String
            inprogressobj.taskdescriptionn = inprogresstask?[indexPath.row].value(forKey: "descriptionn") as? String
            inprogressobj.taskpriorityy = inprogresstask?[indexPath.row].value(forKey: "priority") as? String
            inprogressobj.taskdatee = inprogresstask?[indexPath.row].value(forKey: "date") as? Date
            inprogressobj.taskstatee = inprogresstask?[indexPath.row].value(forKey: "state") as? String
            inprogressobj.id = inprogresstask?[indexPath.row].value(forKey: "id") as? UUID
            self.navigationController?.pushViewController(inprogressobj, animated: true)
        }

    }

}
extension InProgressViewController : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if((reachability!.isReachable()))
        {
            searchfire = searchtasksinfirestore.searchfirestore(arr: firestoreinprogresstasks, searchtext: searchText)
            ProgressTable.reloadData()
        }
        else
        {
            searcharray = searchtasks.searchh(arr: inprogresstask ?? [], searchtext: searchText)
            ProgressTable.reloadData()
        }

    }
}
