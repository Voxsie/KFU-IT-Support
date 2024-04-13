//
//  TicketsFlowCoordinator.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import Swinject
import UIKit

protocol TicketsListFlowCoordinatorInput {}

protocol TicketsListFlowCoordinatorOutput: AuthrozitionFlowCoordinatorProtocol {}

final class TicketsListFlowCoordinator: FlowCoordinatorProtocol {

    // MARK: Private propeties

    private var parentTabbarViewController: UITabBarController?
    private weak var rootViewController: UIViewController?
    private weak var rootNavigationController: UINavigationController?

    private var finishHandlers: [() -> Void] = []

    private let output: TicketsListFlowCoordinatorOutput

    // MARK: Public properties

    var childFlowCoordinators: [FlowCoordinatorProtocol] = []

    // MARK: Lifecycle

    init(
        parentTabbarViewController: UITabBarController,
        output: TicketsListFlowCoordinatorOutput,
        finishHandler: @escaping () -> Void
    ) {
        self.parentTabbarViewController = parentTabbarViewController
        self.output = output

        finishHandlers.append(finishHandler)
    }

    func start(animated: Bool) {
        let builder = TicketsListModuleBuilder(
            moduleOutput: self
        )
        let ticketsListViewController = builder.build()
        rootViewController = ticketsListViewController
        ticketsListViewController.tabBarItem = UITabBarItem(
            title: "Заявки",
            image: UIImage(systemName: "list.dash"),
            tag: 0
        )
        let navigationController = UINavigationController(
            rootViewController: ticketsListViewController
        )
        rootNavigationController = navigationController
        parentTabbarViewController?.appendViewController(
            navigationController,
            animated: false
        )
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
}

// MARK: - TicketsListModuleOutput

extension TicketsListFlowCoordinator: TicketsListModuleOutput {
    func moduleWantsToOpenDetails(_ module: TicketsListModuleInput) {
        guard let rootNavigationController,
              !childFlowCoordinators.isContains(ofType: TicketDetailsFlowCoordinator.self)
        else { return }

        let detailsFlowCoordinator = TicketDetailsFlowCoordinator(
            navigationFlow: .present(Weak(wrappedValue: rootNavigationController)),
            output: self,
            parentRootViewController: rootViewController!,
            parentRootNavigationController: rootNavigationController,
            finishHandler: { [weak self] in
                self?.childFlowCoordinators.remove(TicketDetailsFlowCoordinator.self)
            }
        )
        childFlowCoordinators.append(detailsFlowCoordinator)
        detailsFlowCoordinator.start(animated: true)
    }

    func moduleDidLoad(_ module: TicketsListModuleInput) {
        //
    }

    func moduleDidClose(_ module: TicketsListModuleInput) {
        //
    }
}

// MARK: - TicketDetailsFlowCoordinatorOutput

extension TicketsListFlowCoordinator: TicketDetailsFlowCoordinatorOutput {

}
