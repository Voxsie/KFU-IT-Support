//
//  UserModel.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 25.04.2024.
//

import Foundation

// MARK: - UserModel

struct UserResponseModel: Codable {
    let data: UserData?
}

// MARK: - UserData

struct UserData: Codable {
    let users: Users?
}

// MARK: - Users

struct Users: Codable {
    let userID, user: String?
    let phone: [String]?
    let division, divisionID: String?
    let isManager: Bool?

    enum CodingKeys: String, CodingKey {
        case userID = "UserId"
        case user = "User"
        case phone = "Phone"
        case division = "Division"
        case divisionID = "DivisionID"
        case isManager = "IsManager"
    }
}
