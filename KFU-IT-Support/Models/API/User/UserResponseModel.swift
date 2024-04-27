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
    let error: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decodeIfPresent(UserData.self, forKey: .data)
        self.error = try container.decodeIfPresent(String.self, forKey: .error)
    }
}

// MARK: - UserData

struct UserData: Codable {
    let users: Users?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.users = try container.decodeIfPresent(Users.self, forKey: .users)
    }
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

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decodeIfPresent(String.self, forKey: .userID)
        self.user = try container.decodeIfPresent(String.self, forKey: .user)
        self.phone = try container.decodeIfPresent([String].self, forKey: .phone)
        self.division = try container.decodeIfPresent(String.self, forKey: .division)
        self.divisionID = try container.decodeIfPresent(String.self, forKey: .divisionID)
        self.isManager = try container.decodeIfPresent(Bool.self, forKey: .isManager)
    }
}
