//
//  Error.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 18.04.2024.
//

import Foundation

enum AppError: Error {
    case unknownError

    var localizedDescription: String {
        switch self {
        case .unknownError:
            return "AppError.unknownError"
        }
    }
}

enum LocalServiceError: Error {
    case unknownError
    case notFoundItem
    case parsingError

    var localizedDescription: String {
        switch self {
        case .unknownError:
            return "LocalServiceError.unknownError"

        case .notFoundItem:
            return "LocalServiceError.notFoundItem"

        case .parsingError:
            return "LocalServiceError.parsingError"
        }
    }
}

enum RemoteServiceError: Error {
    case offline
}
