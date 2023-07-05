//
//  Search.swift
//  To-do
//
//  Created by Salma on 12/04/2023.
//

import Foundation
import CoreData

protocol searchinfirestore
{
    static func searchfirestore(arr : [Taskk], searchtext: String)->[Taskk]
}

class searchtasksinfirestore : searchinfirestore
{
    static func searchfirestore(arr: [Taskk], searchtext: String) -> [Taskk]
    {
        var result : [Taskk] = []
        if searchtext == ""
        {
            result = arr
        }
        for matchedobj in arr
        {
            let name = matchedobj.taskname ?? ""
            print(name)
            if (name.uppercased().contains(searchtext.uppercased()))
            {
                result.append(matchedobj)
            }
        }
        return result
    }
}

protocol searcchh {
  static  func searchh (arr : [NSManagedObject], searchtext : String)->[NSManagedObject]
}
class searchtasks : searcchh
{
   static func searchh (arr : [NSManagedObject], searchtext : String)->[NSManagedObject]
    {
        var result : [NSManagedObject] = []
         if searchtext == ""
        {
             result = arr
        }
        for matchobj in arr
        {
            if (matchobj.value(forKey: "name") as? String)!.uppercased().contains(searchtext.uppercased())
            {
                result.append(matchobj)
            }
        }
        return result
    }
}
