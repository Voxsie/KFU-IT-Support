//
//  TabBarFlowCoordinator.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import Swinject
import UIKit

protocol TabBarFlowCoordinatorInput: AnyObject {}

protocol TabBarFlowCoordinatorOutput: AnyObject {
    func flowCoordinatorWantsToOpenUnathorizedZone()
}

final class TabBarFlowCoordinator: WindowableFlowCoordinator {

    // MARK: Private propeties

    private var window: UIWindow?

    private var windowsManager: WindowsManagerProtocol

    private let output: TabBarFlowCoordinatorOutput

    private var finishHandlers: [() -> Void] = []

    private var viewController: UITabBarController?

    // MARK: Public Properties

    var childFlowCoordinators: [FlowCoordinatorProtocol] = []

    // MARK: Lifecycle

    public init(
        windowsManager: WindowsManagerProtocol,
        output: TabBarFlowCoordinatorOutput,
        finishHandler: @escaping () -> Void
    ) {
        self.windowsManager = windowsManager
        self.output = output

        finishHandlers.append(finishHandler)
    }

    // MARK: Public Methods

    func start(animated: Bool, in window: UIWindow) {
        self.window = window
        start(animated: animated)
    }

    func start(animated: Bool) {
        guard let window else { return }

        viewController = UITabBarController()
        configureTabs()

        guard let viewController else { return }

        windowsManager.switchViewController(
            viewController,
            in: window,
            animated: animated,
            completion: { [weak self] in
                self?.didFinish()
            }
        )
    }

    func finish(animated: Bool, completion: (() -> Void)?) {
        if let completion {
            finishHandlers.append(completion)
        }

        if let viewController {
            viewController.dismissIfPresenting(animated: false)
        } else {
            didFinish()
        }
    }

    // MARK: Private methods

    private func didFinish() {
        finishHandlers.forEach { $0() }
        finishHandlers.removeAll()
    }
}

private extension TabBarFlowCoordinator {

    // MARK: Public Methods

    func configureTabs() {
        addTicketModule()
        addSettingsModule()
    }

    func addTicketModule() {
        guard let viewController else { return }
        let ticketFlowCoordinator = TicketsListFlowCoordinator(
            parentTabbarViewController: viewController,
            output: self,
            finishHandler: { [weak self] in
                self?.childFlowCoordinators.remove(TicketsListFlowCoordinator.self)
            }
        )
        childFlowCoordinators.append(ticketFlowCoordinator)
        ticketFlowCoordinator.start(animated: false)
    }

    func addSettingsModule() {
        guard let viewController else { return }
        let settingsFlowCoordinator = SettingsFlowCoordinator(
            parentTabbarViewController: viewController, 
            output: self,
            finishHandler: { [weak self] in
                self?.childFlowCoordinators.remove(SettingsFlowCoordinator.self)
            }
        )
        childFlowCoordinators.append(settingsFlowCoordinator)
        settingsFlowCoordinator.start(animated: false)
    }
}

extension TabBarFlowCoordinator: 
    TicketsListFlowCoordinatorOutput,
    SettingsFlowCoordinatorOutput
{
    func flowCoordinatorWantsToOpenUnathorizedZone() {
        output.flowCoordinatorWantsToOpenUnathorizedZone()
    }
}
