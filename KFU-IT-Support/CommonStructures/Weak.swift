//
//  Weak.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import Foundation

public final class Weak<Wrapped> {

    // MARK: Private properties

    private weak var value: AnyObject?

    // MARK: Public properties

    public var wrappedValue: Wrapped? {
        return value as? Wrapped
    }

    public init(wrappedValue: Wrapped) {
        self.value = value as AnyObject?
    }
}
