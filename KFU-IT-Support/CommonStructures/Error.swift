//
//  Error.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 18.04.2024.
//

import Foundation

enum AppError: Error {
    case unknownError(
        fileID: String = #fileID,
        function: String = "<function>",
        line: UInt = #line
    )

    var localizedDescription: String {
        switch self {
        case .unknownError:
            return "AppError.unknownError"
        }
    }
}

enum LocalServiceError: Error {
    case unknownError(
        fileID: String = #fileID,
        function: String = "<function>",
        line: UInt = #line
    )

    case notFoundItem(
        fileID: String = #fileID,
        function: String = "<function>",
        line: UInt = #line
    )

    case parsingError(
        fileID: String = #fileID,
        function: String = "<function>",
        line: UInt = #line
    )

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
    case offline(
        fileID: String = #fileID,
        function: String = "<function>",
        line: UInt = #line
    )

    case noVPN(
        fileID: String = #fileID,
        function: String = "<function>",
        line: UInt = #line
    )

    case notAuthenticated(
        fileID: String = #fileID,
        function: String = "<function>",
        line: UInt = #line
    )
}
