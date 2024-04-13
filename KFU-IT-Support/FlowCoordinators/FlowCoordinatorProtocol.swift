//
//  FlowCoordinatorProtocol.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import Foundation

protocol FlowCoordinatorProtocol {
    var childFlowCoordinators: [FlowCoordinatorProtocol] { get set }

    func start(animated: Bool)
    func finish(animated: Bool, completion: (() -> Void)?)
}

extension Array where Element == FlowCoordinatorProtocol {

    mutating func remove<T: FlowCoordinatorProtocol>(_ flowCoordinator: T.Type) {
        guard let index = firstIndex(where: { $0 is T }) else { return }
        remove(at: index)
    }

    func isContains<T: FlowCoordinatorProtocol>(ofType type: T.Type) -> Bool {
        if let founded = first(where: { $0 is T }) as? T {
            return true
        } else {
            return false
        }
    }
}
