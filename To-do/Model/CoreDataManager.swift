//
//  CoreDataManager.swift
//  To-do
//
//

import CoreData
import UIKit

class CoreDataManager
{
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    
    let managedcontext: NSManagedObjectContext!
    let entity: NSEntityDescription!
    
    private static var CoreDataObj: CoreDataManager?
    
    public static func getobj () -> CoreDataManager
    {
        if let obj = CoreDataObj
        {
            return obj
        }
        else
        {
            CoreDataObj = CoreDataManager()
            return CoreDataObj!
        }
    }
    
    private init()
    {
        managedcontext = appdelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "CoreData", in: managedcontext)
    }
    
    func SaveToCoreDate(title: String, description: String, date: Date, priority: String, state: String, useremail: String)
    {
        let taskk = NSEntityDescription.insertNewObject(forEntityName: "CoreData", into: managedcontext)
        
        taskk.setValue(UserDefaults.standard.value(forKey: "useremail"), forKey: "useremail")
        taskk.setValue(title, forKey: "name")
        taskk.setValue(description, forKey: "descriptionn")
        taskk.setValue(date, forKey: "date")
        taskk.setValue(priority, forKey: "priority")
        taskk.setValue(state, forKey: "state")
        taskk.setValue(UUID(), forKey: "id")
        try?self.managedcontext.save()
        print("Saved to CoreData")
    }
    
    func FetchCoreData(state: String, user: String)-> [NSManagedObject]?
    {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreData")
 
        fetchRequest.predicate = NSPredicate(format: "state = %@ AND useremail = %@", state , user)
        if let arr = try? managedcontext.fetch(fetchRequest)
        {
            if arr.count > 0
            {
                return arr
            }
        return nil
    }
        else{
            return nil
        }
    }
    
    
    func FetchCoreData()-> [NSManagedObject]?
    {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreData")
        if let arr = try? managedcontext.fetch(fetchRequest)
        {
            if arr.count > 0
            {
                return arr
            }
            return nil
        }
        else{
            return nil
        }
    }
    
    func DeleteTask (uuid : UUID)
    {
        if let arrayoftasks = FetchCoreData()
        {
            for matchedtask in arrayoftasks
            {
                if matchedtask.value(forKey: "id") as! UUID == uuid
                {
                    managedcontext.delete(matchedtask)
                    try?managedcontext.save()
                    
                }
            }
        }
    }
    
    func EditTask(title: String, description: String, date: Date, priority: String, state: String, uuid: UUID)
    {
        if let arrayoftasks = FetchCoreData()
        {
            for matchedtask in arrayoftasks
            {
                if matchedtask.value(forKey: "id") as! UUID == uuid
                {
                    matchedtask.setValue(title, forKey: "name")
                    matchedtask.setValue(description, forKey: "descriptionn")
                    matchedtask.setValue(date, forKey: "date")
                    matchedtask.setValue(priority, forKey: "priority")
                    matchedtask.setValue(state, forKey: "state")
                    matchedtask.setValue(uuid, forKey:"id")
                    try?managedcontext.save()
                    print("Edited")
                }
            }
        }
    }
}

