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

    private var isExample = false
    private var isAuthorized = false

    // MARK: Public properties

    var childFlowCoordinators: [FlowCoordinatorProtocol] = []

    // MARK: Lifecycle

    // MARK: Public methods

    func start(animated: Bool, in window: UIWindow) {
        self.window = window
        start(animated: animated)
    }

    func start(animated: Bool) {
        UserDefaultManager.shared.set(false, for: .offlineMode)
        updateZone()
    }

    func finish(animated: Bool, completion: (() -> Void)?) {
       // unused
    }

    private func updateZone() {
        if isExample {
            openExample()
        } else {
            if isAuthorized {
                openAuthorizedZone()
            } else {
                openUnauthorizedZone()
            }
        }
    }

    private func openExample() {
        guard let window else { return }
        let navigationVC = UINavigationController()
        navigationVC.view.backgroundColor = .red
        window.rootViewController = navigationVC

        window.makeKeyAndVisible()

        guard
            let rootVC = window.rootViewController,
            let navRootVC = rootVC as? UINavigationController
        else { return }

        let coordinator = TicketClosingFlowCoordinator(
            ticketID: "example",
            navigationFlow: .present(.init(wrappedValue: window.rootViewController ?? navigationVC)),
            output: self,
            parentRootViewController: rootVC,
            parentRootNavigationController: navRootVC,
            finishHandler: { [weak self] in
                self?.childFlowCoordinators.remove(TicketClosingFlowCoordinator.self)
            }
        )
        childFlowCoordinators.append(coordinator)
        coordinator.start(animated: true)
    }

    private func openAuthorizedZone() {
        guard let window else { return }

        let coordinator = TabBarFlowCoordinator(
            windowsManager: WindowsManager(),
            output: self,
            finishHandler: { [weak self] in
                self?.childFlowCoordinators.remove(TabBarFlowCoordinator.self)
            }
        )
        childFlowCoordinators.append(coordinator)
        coordinator.start(animated: true, in: window)
    }

    private func openUnauthorizedZone() {
        guard let window else { return }

        let coordinator = AuthFlowCoordinator(
            window: window,
            windowsManager: WindowsManager(),
            output: self,
            finishHandler: { [weak self] in
                self?.childFlowCoordinators.remove(AuthFlowCoordinator.self)
            }
        )
        childFlowCoordinators.append(coordinator)
        coordinator.start(animated: true)
    }
}

extension RootFlowCoordinator: AuthFlowCoordinatorOutput {
    func flowCoordinatorWantsToOpenAuthorizedZone() {
        isAuthorized = true
        updateZone()
    }
}

extension RootFlowCoordinator: TabBarFlowCoordinatorOutput {
    func flowCoordinatorWantsToOpenUnathorizedZone() {
        isAuthorized = false
        updateZone()
    }
}

extension RootFlowCoordinator: TicketClosingFlowCoordinatorOutput {
    func flowCoordinatorWantsToUpdateData(
        _ flowInput: TicketClosingFlowCoordinatorInput
    ) {
        // unused
    }
}

extension RootFlowCoordinator: SelectListFlowCoordinatorOutput {}
