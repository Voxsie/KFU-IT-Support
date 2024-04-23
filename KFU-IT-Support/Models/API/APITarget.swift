//
//  APITarget.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 18.04.2024.
//

import Foundation

enum APIType {
    case getTicketsList(phone: String, accessKey: String)
    case addComment(TargetBody.Comment)
}
