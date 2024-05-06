//
//  TicketClosingFlowCoordinator.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 08.04.2024.
//

import Foundation
import UIKit

protocol TicketClosingFlowCoordinatorInput: AnyObject {}

protocol TicketClosingFlowCoordinatorOutput: AnyObject {
    func flowCoordinatorWantsToUpdateData(
        _ flowInput: TicketClosingFlowCoordinatorInput
    )
}

final class TicketClosingFlowCoordinator: FlowCoordinatorProtocol {

    // MARK: Private propeties

    private let navigationFlow: NavigationFlow

    private let output: TicketClosingFlowCoordinatorOutput

    private let ticketID: String

    private var finishHandlers: [() -> Void] = []

    private var parentRootViewController: UIViewController
    private var parentRootNavigationController: UINavigationController

    private weak var rootViewController: UIViewController?
    private weak var rootNavigationController: UINavigationController?

    private weak var moduleInput: TicketClosingModuleInput?

    var childFlowCoordinators: [FlowCoordinatorProtocol] = []

    init(
        ticketID: String,
        navigationFlow: NavigationFlow,
        output: TicketClosingFlowCoordinatorOutput,
        parentRootViewController: UIViewController,
        parentRootNavigationController: UINavigationController,
        finishHandler: @escaping () -> Void
    ) {
        self.ticketID = ticketID
        self.navigationFlow = navigationFlow
        self.output = output
        self.parentRootViewController = parentRootViewController
        self.parentRootNavigationController = parentRootNavigationController

        finishHandlers.append(finishHandler)
    }

    func start(animated: Bool) {
        let builder = TicketClosingModuleBuilder(
            ticketID: ticketID,
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

// MARK: - TicketClosingFlowCoordinatorInput

extension TicketClosingFlowCoordinator: TicketClosingFlowCoordinatorInput {}

// MARK: - TicketClosingModuleOutput

extension TicketClosingFlowCoordinator: TicketClosingModuleOutput {

    func moduleWantsToUpdateData(
        _ module: TicketClosingModuleInput
    ) {
        output.flowCoordinatorWantsToUpdateData(self)
    }

    func moduleWantsToOpenSelectList(
        _ module: TicketClosingModuleInput,
        title: String,
        items: [SelectListViewState.DisplayData],
        type: SelectListViewState.SelectType
    ) {
        guard
            let rootViewController, let rootNavigationController else { return }

        let coordinator = SelectListFlowCoordinator(
            navigationFlow: .present(.init(wrappedValue: rootViewController)),
            output: self,
            title: title,
            items: items,
            type: type,
            parentRootViewController: rootViewController,
            parentRootNavigationController: rootNavigationController,
            finishHandler: { [weak self] in
                self?.childFlowCoordinators.remove(TicketClosingFlowCoordinator.self)
            }
        )
        childFlowCoordinators.append(coordinator)
        coordinator.start(animated: true)
    }

    func moduleDidLoad(_ module: TicketClosingModuleInput) {
        //
    }

    func moduleDidClose(_ module: TicketClosingModuleInput) {
        didFinish()
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

// MARK: - TicketClosingFlowCoordinatorOutput

extension TicketClosingFlowCoordinator: SelectListFlowCoordinatorOutput {
    func flowCoordinatorWantsToUpdateItems(
        _ flowInput: SelectListFlowCoordinatorInput,
        items: [SelectListViewState.DisplayData]
    ) {
        moduleInput?.moduleWantsToUpdateItems(items: items)
    }
}
