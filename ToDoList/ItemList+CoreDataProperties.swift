//
//  ItemList+CoreDataProperties.swift
//  ToDoList
//
//  Created by Yasir  on 12/15/21.
//
//

import Foundation
import CoreData


extension ItemList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemList> {
        return NSFetchRequest<ItemList>(entityName: "ItemList")
    }

    @NSManaged public var date: Date?
    @NSManaged public var task: String?
    @NSManaged public var mark: Bool

}

extension ItemList : Identifiable {

}
