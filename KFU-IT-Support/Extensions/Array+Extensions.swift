//
//  Array+Extensions.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 21.04.2024.
//

import Foundation

extension Array {
    mutating func appendIfNotNil(_ element: Element?) {
        if let value = element {
            self.append(value)
        }
    }
}
