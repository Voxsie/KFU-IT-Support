//
//  Collection+Extensions.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 12.04.2024.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
