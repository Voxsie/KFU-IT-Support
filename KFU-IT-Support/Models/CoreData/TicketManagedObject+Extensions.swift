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
        let fineMO = context.findOrCreateManagedObjectByID(
            entityName: "TicketManagedObject",
            propertyID: "id",
            value: responseModel.id
        ) as! TicketManagedObject

        fineMO.id = responseModel.id
        fineMO.number = responseModel.number
        fineMO.requestType = responseModel.requestType
        fineMO.desc = responseModel.description
        fineMO.clientName = responseModel.clientName
        fineMO.clientAddress = responseModel.clientAddress
        fineMO.addressID = responseModel.addressID
        fineMO.buildingID = responseModel.buildingID
        fineMO.clientRoom = responseModel.clientRoom
        fineMO.clientPhone = responseModel.clientPhone
        fineMO.requestDate = responseModel.requestDate
        fineMO.desc = responseModel.deadline
        fineMO.ishot = responseModel.ishot ?? false
        fineMO.coExecutors = responseModel.coExecutors

        return fineMO
    }
}
