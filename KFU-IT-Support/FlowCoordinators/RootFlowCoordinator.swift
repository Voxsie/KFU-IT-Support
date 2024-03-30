//
//  RootFlowCoordinator.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 30.03.2024.
//

import UIKit

final class RootFlowCoordinator: WindowableFlowCoordinator {

    // MARK: Private properties

    private var window: UIWindow?

    // MARK: Public properties

    var childFlowCoordinators: [FlowCoordinatorProtocol] = []

    // MARK: Lifecycle

    // MARK: Public methods

    func start(animated: Bool, in window: UIWindow) {
        self.window = window
        start(animated: animated)
    }

    // TODO: Исправить инициализацию WindowsManager

    func start(animated: Bool) {
        guard let window else { return }

        let coordinator = TabBarFlowCoordinator(
            windowsManager: WindowsManager()
        )
        childFlowCoordinators.append(coordinator)
        coordinator.start(animated: true, in: window)

//        let greyZoneFlowCoordinator = GreyZoneFlowCoordinator(
//            window: window,
//            windowsManager: WindowsManager()
//        )
//        childFlowCoordinators.append(greyZoneFlowCoordinator)
//        greyZoneFlowCoordinator.start(animated: animated)
    }

    func finish(animated: Bool, completion: (() -> Void)?) {
       // unused
    }
}
