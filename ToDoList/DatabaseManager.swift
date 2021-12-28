//
//  DatabaseManager.swift
//  ToDoList
//
//  Created by Yasir  on 12/13/21.
//

import Foundation
import UIKit

class DatabaseManager
{
    private var taskList = [ItemList]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    func createTask(taskData : String,flag:Bool)
    {
        let newItem = ItemList(context: context)
        newItem.task = taskData
        newItem.date = Date()
        newItem.mark = flag
        
        do{
            try context.save()
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    func getTasks() -> [ItemList]
    {
        do{
            taskList = try context.fetch(ItemList.fetchRequest())
        }
        catch
        {
            print(error.localizedDescription)
        }
        return taskList
    }
    
    
    
    func deleteTask(indexPath:IndexPath)
    {
        let eventArrayItem = taskList[indexPath.row]
        context.delete(eventArrayItem)
            do {
                try context.save()
            }
        catch let error as NSError {
            print("Error While Deleting Note: \(error.userInfo)")}
    }
    func updateTask(item:ItemList,taskData: String)
    {
        item.task = taskData
     
        do{
            try context.save()
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
    func updateMark(item:ItemList,flag:Bool)
    {
        item.mark = flag
        do{
            try context.save()
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
}
