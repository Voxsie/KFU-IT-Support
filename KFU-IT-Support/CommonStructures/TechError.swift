//
//  TechError.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 07.04.2024.
//

import Foundation

enum TechError: CustomNSError {
    case unexpectedNil(
        Any.Type,
        fileID: String = #fileID,
        function: String = "<function>",
        line: UInt = #line
    )
}
