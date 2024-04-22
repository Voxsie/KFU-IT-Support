//
//  TicketManagedObject+CoreDataProperties.swift
//  
//
//  Created by Ilya Zheltikov on 21.04.2024.
//
//

import Foundation
import CoreData

extension TicketManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TicketManagedObject> {
        return NSFetchRequest<TicketManagedObject>(entityName: "TicketManagedObject")
    }

    @NSManaged public var addressID: String?
    @NSManaged public var buildingID: String?
    @NSManaged public var clientAddress: String?
    @NSManaged public var clientName: String?
    @NSManaged public var clientPhone: String?
    @NSManaged public var clientRoom: String?
    @NSManaged public var coExecutors: String?
    @NSManaged public var deadline: String?
    @NSManaged public var desc: String?
    @NSManaged public var id: String?
    @NSManaged public var ishot: Bool
    @NSManaged public var number: String?
    @NSManaged public var requestDate: String?
    @NSManaged public var requestType: String?
}
