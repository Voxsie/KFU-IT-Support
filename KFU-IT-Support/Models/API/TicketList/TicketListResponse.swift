//
//  TicketsListResponse.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 18.04.2024.
//

import Foundation

// MARK: - TicketsListResponse

struct TicketsListResponse: Codable {
    let data: TicketsListData?
    let error: String?
}

// MARK: - TicketsListData

struct TicketsListData: Codable {
    let userID: String?
    let requests: [TicketItem]?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case requests
    }
}

// MARK: - TicketsListRequest
struct TicketItem: Codable, Equatable {
    
    let id, number, requestType, description: String?
    let clientName, clientAddress, addressID, buildingID: String?
    let clientRoom, clientPhone, requestDate, deadline: String?
    let ishot: Bool?
    let coExecutors: String?
    let comments: [TicketsListComment]?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case number = "Number"
        case requestType = "RequestType"
        case description = "Description"
        case clientName = "ClientName"
        case clientAddress = "ClientAddress"
        case addressID = "AddressId"
        case buildingID = "BuildingId"
        case clientRoom = "ClientRoom"
        case clientPhone = "ClientPhone"
        case requestDate = "RequestDate"
        case deadline = "Deadline"
        case ishot = "Ishot"
        case coExecutors = "Co-executors"
        case comments = "Comments"
    }

    init(from managedObject: TicketManagedObject) {
        self.id = managedObject.id
        self.number = managedObject.number
        self.requestType = managedObject.requestType
        self.description = managedObject.desc
        self.clientName = managedObject.clientName
        self.clientAddress = managedObject.clientAddress
        self.addressID = managedObject.addressID
        self.buildingID = managedObject.buildingID
        self.clientRoom = managedObject.clientRoom
        self.clientPhone = managedObject.clientPhone
        self.requestDate = managedObject.requestDate
        self.deadline = managedObject.deadline
        self.ishot = managedObject.ishot
        self.coExecutors = managedObject.coExecutors
        self.comments = []
    }

    static func == (lhs: TicketItem, rhs: TicketItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.number == rhs.number &&
        lhs.requestType == rhs.requestType &&
        lhs.description == rhs.description &&
        lhs.clientName == rhs.clientName &&
        lhs.clientAddress == rhs.clientAddress &&
        lhs.addressID == rhs.addressID &&
        lhs.buildingID == rhs.buildingID &&
        lhs.clientRoom == rhs.clientRoom &&
        lhs.clientPhone == rhs.clientPhone &&
        lhs.requestDate == rhs.requestDate &&
        lhs.deadline == rhs.deadline &&
        lhs.ishot == rhs.ishot &&
        lhs.coExecutors == rhs.coExecutors
    }
}

// MARK: - TicketsListComment

struct TicketsListComment: Codable {
    let executor: String?
    let comment: String?
    let beginDate: String?
    let endDate: String?

    enum CodingKeys: String, CodingKey {
        case executor = "Executor"
        case comment = "Comment"
        case beginDate = "beginDate"
        case endDate = "endDate"
    }
}
