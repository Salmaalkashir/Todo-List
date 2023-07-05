//
//  FireStore.swift
//  To-do
//
//  Created by Salma on 30/04/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

class Add
{
    
    static func addtask(namee: String, desc: String, prio: String, dateee: String, stateee: String, messegeSender: String , completion: @escaping (Error?)->Void)
    {

        let db = Firestore.firestore()
        let messageSender = Auth.auth().currentUser?.email
    
        
        db.collection("tasks").addDocument(data: ["namee" : namee, "desc": desc, "prio" : prio,"stateee" : stateee, "dateee": dateee, "messageSender": messageSender, "time" : Date().timeIntervalSince1970])
            {
                (error) in
                if let e = error {
                    completion(e)
                }
                else
                {
                    completion(nil)
                }
            }
        }
}

class Retrieve
{
    static func loadtasks(state: String, completion: @escaping (([Taskk])->Void))
    {
        let date = Date()
        let log = UserDefaults()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        dateFormatter.string(from: date)
        let db = Firestore.firestore()
        var statetasks : [Taskk] = [] 
        db.collection("tasks").order(by: "time").addSnapshotListener { docSnapshot, error in
            guard let doc = docSnapshot else{
                print("error retrievig data: \(error)")
                return
            }
            if let snapshotDoc = docSnapshot?.documents
            {
                statetasks = []
                for doc in snapshotDoc
                {
                    let data = doc.data()
                    if let statte = data["stateee"], let userr = data["messageSender"]
                    {
                        let t = Taskk(taskname: data["namee"] as? String, taskdescription: data["desc"] as? String, taskpriority: data["prio"] as? String, taskdate: dateFormatter.date(from: data["dateee"] as? String ?? ""), taskstate: data["stateee"] as? String , id: doc.documentID as? String)
                       
                        if statte as? String == state && userr as? String == Auth.auth().currentUser?.email as? String
                        {
                            statetasks.append(t)
                        }
                        DispatchQueue.main.async {
                            completion(statetasks)
                        }
                    }
                }
                
            }
        }
    }
}
class Delete
{
    
    static func deletetask(id: String)
    {
        let db = Firestore.firestore()
        db.collection("tasks").order(by: "time").addSnapshotListener { docSnapshot, error in
            guard let doc = docSnapshot else{
                print("error retrievig data")
                return
            }
            if let snapshotDoc = docSnapshot?.documents
            {
                for doc in snapshotDoc
                {
                    print(doc.documentID)
                    print("id:\(id)")
                    if id == doc.documentID
                    {
                    
                        db.collection("tasks").document(id).delete()
                        print("deleted")
                    }
                    else
                    {
                        print("error deleting")
                    }
                }
            }
        }
    }
}
class Edit
{
    static func edittaskk(namee: String, desc: String, prio: String, stateee: String, dateee: String, id: String)
    {
        let db = Firestore.firestore()
        db.collection("tasks").order(by: "time").addSnapshotListener { docSnapshot, error in
            guard let doc = docSnapshot else{
                print("error retrievig data")
                return
            }
            if let snapshotDoc = docSnapshot?.documents
            {
                for doc in snapshotDoc
                {
                    if id == doc.documentID
                    {
                        
                        db.collection("tasks").document(id).updateData(["namee" : namee, "desc": desc, "prio" : prio,"stateee" : stateee, "dateee": dateee])
                        print("edited")
                    }
                    else
                    {
                        print("no edits")
                    }
                }
            }
        }
    }
}
