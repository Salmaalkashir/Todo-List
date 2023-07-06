//
//  ToDoViewController.swift
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


class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchbarr: UISearchBar!
    @IBOutlet weak var ToDoTable: UITableView!
    @IBOutlet weak var addbtn: UIButton!
    var coreobjvm : CoreDataViewModel?
    var tasksarray : [NSManagedObject]?
    var searcharray : [NSManagedObject]?
    var searchfire : [Taskk]?
    let db = Firestore.firestore()
    var firestoretodotasks : [Taskk] = []
    var reachability : Reachability?
    var firestoreobjvm : FireStoreViewModel?
    var log = UserDefaults()
    var user = UserDefaults.standard.string(forKey: "useremail") ?? ""
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "ToDoTableViewCell", bundle: nil)
        ToDoTable.register(nib, forCellReuseIdentifier: "todocell")
        
        ToDoTable.delegate = self
        ToDoTable.dataSource = self

        searchbarr.delegate = self
        
        coreobjvm = CoreDataViewModel()
        reachability = Reachability.forInternetConnection()
        firestoreobjvm = FireStoreViewModel()
        firestoreobjvm?.gettasks(state: "ToDo")
        firestoreobjvm?.bindingretrievedtaskstocontrollers = {
            DispatchQueue.main.async {
                self.firestoretodotasks = self.firestoreobjvm?.retrievedtasks ?? []
                self.searchfire = self.firestoretodotasks
                self.ToDoTable.reloadData()
            }
        }
    }
    
    @IBAction func add(_ sender: Any) {
        let addobj : AddTaskkViewController = self.storyboard?.instantiateViewController(withIdentifier: "addtaskk") as! AddTaskkViewController
        self.navigationController?.pushViewController(addobj, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        ApplyConstraints()

        tasksarray = coreobjvm?.fetchdata(state: "ToDo", user: UserDefaults.standard.string(forKey: "useremail") ?? "")
        searcharray = tasksarray
        searchfire = firestoretodotasks
        
        
    }
    
    @IBAction func logoutt(_ sender: Any) {
        log.setValue(false, forKey: "islogged")
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
            cell.taskname.text = searchfire?[indexPath.row].taskname
            cell.datetask.date = searchfire?[indexPath.row].taskdate ?? Date()
        }
        else
        {
            cell.taskname.text = searcharray?[indexPath.row].value(forKey: "name") as? String
            cell.datetask.date = searcharray?[indexPath.row].value(forKey: "date") as? Date ?? Date()
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
                    print(self.searchfire?[indexPath.row].id)
                    self.ToDoTable.reloadData()
                }
                else
                {
                    self.coreobjvm?.deletetaskk(uuid: self.searcharray?[indexPath.row].value(forKey: "id") as! UUID)
                    self.searcharray = self.coreobjvm?.fetchdata(state: "ToDo", user: UserDefaults.standard.string(forKey: "useremail") ?? "")
                    self.ToDoTable.reloadData()
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel))
            present(alert, animated: true , completion: nil)
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if((reachability!.isReachable()))
        {
            let fireobjedit = self.storyboard?.instantiateViewController(withIdentifier: "edittask") as! EditTaskViewController
            
            fireobjedit.tasktitle = firestoretodotasks[indexPath.row].taskname
            fireobjedit.taskdescriptionn = firestoretodotasks[indexPath.row].taskdescription
            fireobjedit.taskpriorityy = firestoretodotasks[indexPath.row].taskpriority
            fireobjedit.taskdatee = firestoretodotasks[indexPath.row].taskdate
            fireobjedit.taskstatee = firestoretodotasks[indexPath.row].taskstate
            fireobjedit.indexpath = firestoretodotasks[indexPath.row].id 
            
            self.navigationController?.pushViewController(fireobjedit, animated: true)
        }
        else
        {
            let editobj = self.storyboard?.instantiateViewController(withIdentifier: "edittask") as! EditTaskViewController
            
            editobj.tasktitle = tasksarray?[indexPath.row].value(forKey: "name") as? String
            editobj.taskdescriptionn = tasksarray?[indexPath.row].value(forKey: "descriptionn") as? String
            editobj.taskpriorityy = tasksarray?[indexPath.row].value(forKey: "priority") as? String
            editobj.taskdatee = tasksarray?[indexPath.row].value(forKey: "date") as? Date
            editobj.taskstatee = tasksarray?[indexPath.row].value(forKey: "state") as? String
            editobj.id = tasksarray?[indexPath.row].value(forKey: "id") as? UUID
            self.navigationController?.pushViewController(editobj, animated: true)
        }
       
    }
    
    func ApplyConstraints()
    {
        addbtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addbtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -1 * (UIScreen.main.bounds.height / 20)),
              addbtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
              addbtn.heightAnchor.constraint(equalToConstant: 50),
              addbtn.widthAnchor.constraint(equalToConstant: 50)
          ])
    }

}
extension ToDoViewController : UISearchBarDelegate 
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if((reachability!.isReachable()))
        {
            searchfire = searchtasksinfirestore.searchfirestore(arr: firestoretodotasks, searchtext: searchText)
            ToDoTable.reloadData()
        }
        else
        {
            searcharray = searchtasks.searchh(arr: tasksarray ?? [], searchtext: searchText)
            ToDoTable.reloadData()
        }

    }

}


