//
//  TicketDetailsFlowCoordinator.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 07.04.2024.
//

import Swinject
import UIKit

protocol TicketDetailsFlowCoordinatorInput: AnyObject {}

protocol TicketDetailsFlowCoordinatorOutput: AnyObject {}

final class TicketDetailsFlowCoordinator: FlowCoordinatorProtocol {

    // MARK: Private propeties

    private let navigationFlow: NavigationFlow

    private let uuid: String

    private let output: TicketDetailsFlowCoordinatorOutput

    private var finishHandlers: [() -> Void] = []

    private var parentRootViewController: UIViewController
    private var parentRootNavigationController: UINavigationController

    private weak var rootViewController: UIViewController?
    private weak var rootNavigationController: UINavigationController?

    var childFlowCoordinators: [FlowCoordinatorProtocol] = []

    init(
        navigationFlow: NavigationFlow,
        uuid: String,
        output: TicketDetailsFlowCoordinatorOutput,
        parentRootViewController: UIViewController,
        parentRootNavigationController: UINavigationController,
        finishHandler: @escaping () -> Void
    ) {
        self.navigationFlow = navigationFlow
        self.uuid = uuid
        self.output = output
        self.parentRootViewController = parentRootViewController
        self.parentRootNavigationController = parentRootNavigationController

        finishHandlers.append(finishHandler)
    }

    func start(animated: Bool) {
        let builder = TicketDetailsModuleBuilder(
            moduleOutput: self,
            uuid: uuid
        )
        let viewController = builder.build()
        rootViewController = viewController
        let navigationController = UINavigationController(
            rootViewController: viewController
        )
        rootNavigationController = navigationController

        parentRootNavigationController.present(navigationController, animated: true)

//        do {
//            switch navigationFlow {
//            case let .present(parentViewControllerWrapper):
//                let parentViewController = try parentViewControllerWrapper.wrappedValue.unwrap()
//                parentViewController.present(navigationController, animated: animated)
//
//            case let .push(parentNavControllerWrapper):
//                let navigationController = try parentNavControllerWrapper.wrappedValue.unwrap()
//                rootNavigationController = navigationController
//                navigationController.pushViewController(
//                    navigationController,
//                    animated: true
//                )
//            }
//        } catch {
//            print(error)
//        }
    }

    func finish(animated: Bool, completion: (() -> Void)?) {
        if let completion {
            finishHandlers.append(completion)
        }

        do {
            switch navigationFlow {
            case let .present(parentViewControllerWrapper):
                let parentViewController = try parentViewControllerWrapper.wrappedValue.unwrap()
                parentViewController.dismissIfPresenting(
                    animated: animated,
                    completion: nil
                )

            case .push:
                rootNavigationController.mapOrLog { $0.popViewController(animated: true) }
            }
        } catch {
            didFinish()
        }
    }

    // MARK: Private methods

    private func didFinish() {
        finishHandlers.forEach { $0() }
        finishHandlers.removeAll()
    }
}

// MARK: - TicketDetailsModuleOutput

extension TicketDetailsFlowCoordinator: TicketDetailsModuleOutput {

    func moduleUnload(_ module: TicketDetailsModuleInput) {
        didFinish()
    }

    func moduleWantsToClose(_ input: TicketDetailsModuleInput) {
        if rootViewController?.presentedViewController != nil || rootViewController?.presentingViewController != nil {
            rootViewController?.dismiss(animated: true, completion: nil)
        } else {
            rootViewController.map {
                _ = rootNavigationController?.popToViewController($0, animated: true)
            }
        }
    }

    func moduleWantsToCloseCloseTicket(_ input: TicketDetailsModuleInput) {
        guard let rootNavigationController,
              !childFlowCoordinators.isContains(ofType: TicketClosingFlowCoordinator.self)
        else { return }

        let closingFlowCoordinator = TicketClosingFlowCoordinator(
            ticketID: uuid,
            navigationFlow: .present(Weak(wrappedValue: rootNavigationController)),
            output: self,
            parentRootViewController: rootViewController!,
            parentRootNavigationController: rootNavigationController,
            finishHandler: { [weak self] in
                self?.childFlowCoordinators.remove(TicketClosingFlowCoordinator.self)
            }
        )
        childFlowCoordinators.append(closingFlowCoordinator)
        closingFlowCoordinator.start(animated: true)
    }
}

// MARK: - TicketClosingFlowCoordinatorOutput

extension TicketDetailsFlowCoordinator: TicketClosingFlowCoordinatorOutput {

}
