//
//  TabBarFlowCoordinator.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import Swinject
import UIKit

final class TabBarFlowCoordinator: WindowableFlowCoordinator {

    // MARK: Private propeties

//    private var resolver: Resolver

    private var window: UIWindow?

    private var windowsManager: WindowsManagerProtocol

    // MARK: Public Properties

    var viewController: UITabBarController?

    var childFlowCoordinators: [FlowCoordinatorProtocol] = []

    // MARK: Lifecycle

    public init(
        windowsManager: WindowsManagerProtocol
//        resolver: Resolver
    ) {
        self.windowsManager = windowsManager
//        self.resolver = resolver
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
            completion: {}
        )
    }

    func finish(animated: Bool, completion: (() -> Void)?) {
        viewController?.dismiss(animated: animated)
        viewController = nil
    }
}

private extension TabBarFlowCoordinator {

    // MARK: Public Methods

    func configureTabs() {
        addTicketModule()
    }

    func addTicketModule() {
        guard let viewController else { return }
        let ticketFlowCoordinator = TicketsListFlowCoordinator(
            parentTabbarViewController: viewController
//            resolver: resolver
        )
        ticketFlowCoordinator.start(animated: false)
    }
}
