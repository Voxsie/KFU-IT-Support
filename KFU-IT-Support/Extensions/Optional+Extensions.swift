//
//  Optional+Extensions.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 07.04.2024.
//

import Foundation

extension Optional {
    
    @discardableResult
    func mapOrLog<U>(
        fileID: String = #fileID,
        function: String = "<function>",
        line: UInt = #line,
        transform: (_ unwrapped: Wrapped) throws -> U
    ) rethrows -> U? {
        switch self {
        case let .some(wrapped):
            return try transform(wrapped)
        case .none:
            let error = TechError.unexpectedNil(
                Wrapped.self,
                fileID: fileID,
                function: function,
                line: line
            )
            print("Error: \(error)")
            return nil
        }
    }
    
    func unwrap(
        fileID: String = #fileID,
        function: String = "<function>",
        line: UInt = #line
    ) throws -> Wrapped {
        switch self {
        case let .some(wrapped):
            return wrapped
            
        case .none:
            throw TechError.unexpectedNil(
                Wrapped.self,
                fileID: fileID,
                function: function,
                line: line
            )
        }
    }
    
    func unwrap<T>(
        fileID: String = #fileID,
        function: String = "<function>",
        line: UInt = #line,
        _ transform: (Wrapped) throws -> T
    ) throws -> T {
        let unwrap = try self.unwrap(
            fileID: fileID,
            function: function,
            line: line
        )
        
        return try transform(unwrap)
    }
}

extension Optional<Int> {
    func valueOrZero() -> Int {
        if let self {
            return self
        } else {
            return 0
        }
    }
}
