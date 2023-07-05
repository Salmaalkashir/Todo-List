//
//  ViewModel.swift
//  To-do
//
//  Created by Salma on 09/04/2023.
//

import Foundation
import CoreData

class CoreDataViewModel
{
  private var coredataa = CoreDataManager.getobj()
    
    func fetchdata(state: String, user: String) -> [NSManagedObject]
    {
        return coredataa.FetchCoreData(state: state, user: UserDefaults.standard.string(forKey: "useremail") ?? "") ?? []
    }
    func deletetaskk(uuid : UUID)
    {
        coredataa.DeleteTask(uuid: uuid)
    }
    func savetocoredata(title: String, description: String, date: Date, priority: String, state: String)
    {
        coredataa.SaveToCoreDate(title: title, description: description, date: date, priority: priority, state: state, useremail: UserDefaults.standard.string(forKey: "useremail") ?? "")
    }
    func edittask(title: String, description: String, date: Date, priority: String, state: String, uuid: UUID)
    {
        coredataa.EditTask(title: title, description: description, date: date, priority: priority, state: state, uuid: uuid)
    }
}
class FireStoreViewModel
{
    var bindingretrievedtaskstocontrollers : ( ()->() ) = {}
    
    var retrievedtasks : [Taskk] = [] {
        didSet {
            bindingretrievedtaskstocontrollers()
        }
    }
    
    func gettasks(state: String){
        Retrieve.loadtasks(state: state, completion: { result in
            self.retrievedtasks = result
        })
    }
    
    var binderror : ( ()->() ) = {}
    
    var errors : String = ""
    {
        didSet{
            binderror()
        }
    }
    
    func addtasks(namee: String, desc: String, prio: String, dateee: String, stateee: String, messegeSender: String)
    {
        Add.addtask(namee: namee, desc: desc, prio: prio, dateee: dateee, stateee: stateee, messegeSender: messegeSender, completion: { error in
            self.errors = "error\(error)"
        })
    }
    
    var binderrordelete : ( ()->() ) = {}
    
    var errordelete : String = ""
    {
        didSet
        {
            binderrordelete()
        }
    }
    
    func deletetasks(id: String)
    {
        Delete.deletetask(id: id)
    }
    
    
    var binderroredit : ( ()->() ) = {}
    
    var erroredit : String = ""
    {
        didSet
        {
            binderroredit()
        }
    }
    
    func edittaskkk(namee: String, desc: String, prio: String, stateee: String, dateee: String, id: String)
    {
        Edit.edittaskk(namee: namee, desc: desc, prio: prio, stateee: stateee, dateee: dateee, id: id)
    }
}

