//
//  TicketCommentManagedObject+CoreDataProperties.swift
//  
//
//  Created by Ilya Zheltikov on 21.04.2024.
//
//

import Foundation
import CoreData

extension TicketCommentManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TicketCommentManagedObject> {
        return NSFetchRequest<TicketCommentManagedObject>(entityName: "TicketCommentManagedObject")
    }

    @NSManaged public var beginDate: String?
    @NSManaged public var endDate: String?
    @NSManaged public var comment: String?
    @NSManaged public var techComment: String?
    @NSManaged public var id: String?
    @NSManaged public var hasSent: NSNumber?
    @NSManaged public var photo: Data?

}
