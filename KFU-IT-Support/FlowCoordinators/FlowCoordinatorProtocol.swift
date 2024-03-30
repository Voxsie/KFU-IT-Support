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

