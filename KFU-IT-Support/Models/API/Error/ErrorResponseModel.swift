//
//  ErrorResponseModel.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 26.04.2024.
//

import Foundation

struct ErrorResponseModel: Codable {
    let data: TicketsListData?
    let error: String?
}
