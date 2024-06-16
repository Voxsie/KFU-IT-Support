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

    private var finishHandlers: [() -> Void] = []

    private let userDefaults: UserDefaultManager

    private weak var rootViewController: UIViewController?
    private weak var rootNavigationController: UINavigationController?

    private var isExample = false
    private var isAuthorized = false {
        didSet {
            userDefaults.set(isAuthorized, for: .isAuthorized)
        }
    }

    // MARK: Public properties

    var childFlowCoordinators: [FlowCoordinatorProtocol] = []

    // MARK: Lifecycle

    init(
        userDefaults: UserDefaultManager
    ) {
        self.userDefaults = userDefaults
        isAuthorized = userDefaults.getBool(for: .isAuthorized)
        print(isAuthorized)
    }

    // MARK: Public methods

    func start(animated: Bool, in window: UIWindow) {
        self.window = window
        start(animated: animated)
    }

    func start(animated: Bool) {
        userDefaults.set(false, for: .offlineMode)
        let builder = RootModuleBuilder(
            moduleOutput: self
        )
        let viewController = builder.build()
        rootViewController = viewController
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }

    func finish(animated: Bool, completion: (() -> Void)?) {
        if let completion {
            finishHandlers.append(completion)
        }

        if let rootViewController {
            rootViewController.dismissIfPresenting(animated: false)
        } else {
            didFinish()
        }
    }

    // MARK: Private methods

    private func didFinish() {
        finishHandlers.forEach { $0() }
        finishHandlers.removeAll()
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

// MARK: - AuthFlowCoordinatorOutput

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

// MARK: - TicketClosingFlowCoordinatorOutput

extension RootFlowCoordinator: TicketClosingFlowCoordinatorOutput {

    func flowCoordinatorWantsToUpdateData(
        _ flowInput: TicketClosingFlowCoordinatorInput
    ) {
        // unused
    }
}

// MARK: - RootModuleOutput

extension RootFlowCoordinator: RootModuleOutput {

    func moduleUnload(_ module: any RootModuleInput) {
        didFinish()
    }

    func moduleWantsToOpenAuthorizedZone(_ input: any RootModuleInput) {
        isAuthorized = true
        updateZone()
    }

    func moduleWantsToOpenNotAuthorizedZone(_ input: any RootModuleInput) {
        isAuthorized = false
        updateZone()
    }
}

extension RootFlowCoordinator: SelectListFlowCoordinatorOutput {
    func flowCoordinatorWantsToUpdateItems(
        _ flowInput: SelectListFlowCoordinatorInput,
        items: [SelectListViewState.DisplayData]
    ) {
        // ununsed
    }
}

private extension RootFlowCoordinator {
    func openExample() {
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
}
