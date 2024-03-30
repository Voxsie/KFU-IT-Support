//
//  WindowableFlowCoordinator.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import UIKit

protocol WindowableFlowCoordinator: FlowCoordinatorProtocol {
    func start(animated: Bool, in window: UIWindow)
}
