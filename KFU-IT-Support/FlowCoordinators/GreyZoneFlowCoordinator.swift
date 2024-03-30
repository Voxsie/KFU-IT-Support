//
//  GreyZoneFlowCoordinator.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 30.03.2024.
//

import UIKit

final class GreyZoneFlowCoordinator: FlowCoordinatorProtocol {

    // MARK: Private properties

    private var windowsManager: WindowsManagerProtocol

    private var window: UIWindow?

    // MARK: Public properties

    var childFlowCoordinators: [FlowCoordinatorProtocol] = []

    public init(
        window: UIWindow,
        windowsManager: WindowsManagerProtocol
    ) {
        self.window = window
        self.windowsManager = windowsManager
    }

    func start(animated: Bool) {
//        let moduleBuilder = GreyZoneModuleBuilder(
//            moduleOutput: self
//        )
//        let assembler = Assembler([GeneralAssembly()])
//        let viewController = moduleBuilder.build()

        let viewController = UIViewController()

        guard let window else { return }

        windowsManager.switchViewController(
            viewController,
            in: window,
            animated: animated,
            completion: {}
        )
    }

    func finish(animated: Bool, completion: (() -> Void)?) {
        // unused
    }
}

//extension GreyZoneFlowCoordinator: GreyZoneModuleOutput {
//    func showTabBarModule() {
//        guard let window else { return }
//        let coordinator = TabBarFlowCoordinator(
//            windowsManager: windowsManager,
//            resolver: resolver
//        )
//        childFlowCoordinators.append(coordinator)
//        coordinator.start(animated: true, in: window)
//    }
//}
