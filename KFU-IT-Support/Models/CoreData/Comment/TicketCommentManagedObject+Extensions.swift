//
//  TicketCommentManagedObject+Extensions.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 24.04.2024.
//

import Foundation
import CoreData

// swiftlint:disable all

extension TicketCommentManagedObject {

    @discardableResult
    static func `import`(
        from body: TargetBody.Comment,
        hasSent: Bool = false,
        in context: NSManagedObjectContext
    ) throws -> TicketCommentManagedObject {
        let commentMO = context.findOrCreateManagedObjectByID(
            entityName: "TicketCommentManagedObject",
            propertyID: "id",
            value: body.ticketId
        ) as! TicketCommentManagedObject

        commentMO.id = body.ticketId
        commentMO.beginDate = body.beginDate
        commentMO.endDate = body.endDate
        commentMO.comment = body.comment
        commentMO.techComment = body.techComment
        commentMO.hasSent = NSNumber(value: hasSent)

        if let photo = body.photo {
            commentMO.photo = photo
        }

        return commentMO
    }

    @discardableResult
    static func `import`(
        from remoteItem: TicketsListComment,
        for ticket: TicketItem,
        hasSent: Bool = true,
        in context: NSManagedObjectContext
    ) throws -> TicketCommentManagedObject {
        let commentMO = context.findOrCreateManagedObjectByID(
            entityName: "TicketCommentManagedObject",
            propertyID: "id",
            value: ticket.id
        ) as! TicketCommentManagedObject
        commentMO.id = ticket.id
        commentMO.beginDate = remoteItem.beginDate
        commentMO.endDate = remoteItem.endDate
        commentMO.comment = remoteItem.comment
        commentMO.techComment = remoteItem.comment
        commentMO.hasSent = NSNumber(value: hasSent)

        return commentMO
    }
}

