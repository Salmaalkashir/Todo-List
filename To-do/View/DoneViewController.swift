//
//  DoneViewController.swift
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


class DoneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var DoneTable: UITableView!
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    var coreobjvm : CoreDataViewModel?
    var donetasks : [NSManagedObject]?
    var searcharray : [NSManagedObject]?
    var searchfire : [Taskk]?
    let db = Firestore.firestore()
    var firestoredonetasks : [Taskk] = []
    var reachability : Reachability?
    var firestoreobjvm : FireStoreViewModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "ToDoTableViewCell", bundle: nil)
        DoneTable.register(nib, forCellReuseIdentifier: "todocell")
        
        DoneTable.delegate = self
        DoneTable.dataSource = self
        
        searchbar.delegate = self
        
        coreobjvm = CoreDataViewModel()
        reachability = Reachability.forInternetConnection()
        firestoreobjvm = FireStoreViewModel()
        firestoreobjvm?.gettasks(state: "Done")
        firestoreobjvm?.bindingretrievedtaskstocontrollers = {
            DispatchQueue.main.async {
                self.firestoredonetasks = self.firestoreobjvm?.retrievedtasks ?? []
                self.searchfire = self.firestoredonetasks
                self.DoneTable.reloadData()
            }
        }
        

    }
       override func viewWillAppear(_ animated: Bool) {
           donetasks = coreobjvm?.fetchdata(state: "Done", user: UserDefaults.standard.string(forKey: "useremail") ?? "")
        searcharray = donetasks
        searchfire = firestoredonetasks
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
                self.DoneTable.reloadData()
            }
            else
            {
                self.coreobjvm?.deletetaskk(uuid: self.searcharray?[indexPath.row].value(forKey: "id") as! UUID)
                self.searcharray = self.coreobjvm?.fetchdata(state: "Done", user: UserDefaults.standard.string(forKey: "useremail") ?? "")

                
                self.DoneTable.reloadData()
            }


        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        present(alert, animated: true , completion: nil)
    }

}
extension DoneViewController : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if((reachability!.isReachable()))
        {
            searchfire = searchtasksinfirestore.searchfirestore(arr: firestoredonetasks, searchtext: searchText)
            DoneTable.reloadData()
        }
        else
        {
            searcharray = searchtasks.searchh(arr: donetasks ?? [], searchtext: searchText)
            DoneTable.reloadData()
        }

    }
}
    
