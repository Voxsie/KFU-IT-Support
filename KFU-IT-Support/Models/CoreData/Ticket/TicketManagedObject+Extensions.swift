//
//  TicketManagedObject+Extensions.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 21.04.2024.
//

import Foundation
import CoreData

// swiftlint:disable all

extension TicketManagedObject {

    @discardableResult
    static func `import`(
        from responseModel: TicketItem,
        in context: NSManagedObjectContext
    ) throws -> TicketManagedObject {
        let ticketMO = context.findOrCreateManagedObjectByID(
            entityName: "TicketManagedObject",
            propertyID: "id",
            value: responseModel.id
        ) as! TicketManagedObject

        ticketMO.id = responseModel.id
        ticketMO.number = responseModel.number
        ticketMO.requestType = responseModel.requestType
        ticketMO.desc = responseModel.description
        ticketMO.clientName = responseModel.clientName
        ticketMO.clientAddress = responseModel.clientAddress
        ticketMO.addressID = responseModel.addressID
        ticketMO.buildingID = responseModel.buildingID
        ticketMO.clientRoom = responseModel.clientRoom
        ticketMO.clientPhone = responseModel.clientPhone
        ticketMO.requestDate = responseModel.requestDate
        ticketMO.deadline = responseModel.deadline
        ticketMO.ishot = responseModel.ishot ?? false
        ticketMO.coExecutors = responseModel.coExecutors

        return ticketMO
    }
}
