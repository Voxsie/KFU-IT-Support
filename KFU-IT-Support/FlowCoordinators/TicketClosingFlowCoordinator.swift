//
//  TicketClosingFlowCoordinator.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 08.04.2024.
//

import Foundation
import UIKit

protocol TicketClosingFlowCoordinatorInput: AnyObject {}

protocol TicketClosingFlowCoordinatorOutput: AnyObject {}

final class TicketClosingFlowCoordinator: FlowCoordinatorProtocol {

    // MARK: Private propeties

    private let navigationFlow: NavigationFlow

    private let output: TicketClosingFlowCoordinatorOutput

    private var finishHandlers: [() -> Void] = []

    private var parentRootViewController: UIViewController
    private var parentRootNavigationController: UINavigationController

    private weak var rootViewController: UIViewController?
    private weak var rootNavigationController: UINavigationController?

    var childFlowCoordinators: [FlowCoordinatorProtocol] = []

    init(
        navigationFlow: NavigationFlow,
        output: TicketClosingFlowCoordinatorOutput,
        parentRootViewController: UIViewController,
        parentRootNavigationController: UINavigationController,
        finishHandler: @escaping () -> Void
    ) {
        self.navigationFlow = navigationFlow
        self.output = output
        self.parentRootViewController = parentRootViewController
        self.parentRootNavigationController = parentRootNavigationController

        finishHandlers.append(finishHandler)
    }

    func start(animated: Bool) {
        let builder = TicketClosingModuleBuilder(
            output: self
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

// MARK: - TicketClosingModuleOutput

extension TicketClosingFlowCoordinator: TicketClosingModuleOutput {

    func moduleDidLoad(_ module: TicketClosingModuleInput) {
        //
    }

    func moduleDidClose(_ module: TicketClosingModuleInput) {
        //
    }

    func moduleUnload(_ module: TicketClosingModuleInput) {
        didFinish()
    }

    func moduleWantsToClose(_ input: TicketClosingModuleInput) {
        if rootViewController?.presentedViewController != nil || rootViewController?.presentingViewController != nil {
            rootViewController?.dismiss(animated: true, completion: nil)
        } else {
            rootViewController.map {
                _ = rootNavigationController?.popToViewController($0, animated: true)
            }
        }
    }
}
