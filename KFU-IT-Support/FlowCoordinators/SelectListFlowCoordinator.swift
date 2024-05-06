//
//  SelectListFlowCoordinator.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 12.04.2024.
//

import Foundation
import UIKit

protocol SelectListFlowCoordinatorInput: AnyObject {}

protocol SelectListFlowCoordinatorOutput: AnyObject {
    func flowCoordinatorWantsToUpdateItems(
        _ flowInput: SelectListFlowCoordinatorInput,
        items: [SelectListViewState.DisplayData]
    )
}

final class SelectListFlowCoordinator: FlowCoordinatorProtocol, SelectListFlowCoordinatorInput {

    // MARK: Private propeties

    private let navigationFlow: NavigationFlow

    private let title: String
    private let items: [SelectListViewState.DisplayData]
    private let type: SelectListViewState.SelectType

    private let output: SelectListFlowCoordinatorOutput

    private var finishHandlers: [() -> Void] = []

    private var parentRootViewController: UIViewController
    private var parentRootNavigationController: UINavigationController

    private weak var rootViewController: UIViewController?
    private weak var rootNavigationController: UINavigationController?

    var childFlowCoordinators: [FlowCoordinatorProtocol] = []

    init(
        navigationFlow: NavigationFlow,
        output: SelectListFlowCoordinatorOutput,
        title: String,
        items: [SelectListViewState.DisplayData],
        type: SelectListViewState.SelectType,
        parentRootViewController: UIViewController,
        parentRootNavigationController: UINavigationController,
        finishHandler: @escaping () -> Void
    ) {
        self.navigationFlow = navigationFlow
        self.output = output
        self.title = title
        self.items = items
        self.type = type
        self.parentRootViewController = parentRootViewController
        self.parentRootNavigationController = parentRootNavigationController

        finishHandlers.append(finishHandler)
    }

    func start(animated: Bool) {
        let builder = SelectListModuleBuilder(
            output: self,
            title: title,
            items: items,
            type: type
        )
        let viewController = builder.build()
        rootViewController = viewController
        let navigationController = UINavigationController(
            rootViewController: viewController
        )
        rootNavigationController = navigationController

        parentRootNavigationController.present(navigationController, animated: true)
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

// MARK: - SelectListModuleOutput

extension SelectListFlowCoordinator: SelectListModuleOutput {

    func moduleWantsToSave(
        _ module: SelectListModuleInput,
        items: [SelectListViewState.DisplayData]
    ) {
        output.flowCoordinatorWantsToUpdateItems(self, items: items)
        if rootViewController?.presentedViewController != nil || rootViewController?.presentingViewController != nil {
            rootViewController?.dismiss(animated: true, completion: nil)
        } else {
            rootViewController.map {
                _ = rootNavigationController?.popToViewController($0, animated: true)
            }
        }
    }
    

    func moduleDidLoad(_ module: SelectListModuleInput) {
        //
    }

    func moduleDidClose(_ module: SelectListModuleInput) {
        //
    }

    func moduleUnload(_ module: SelectListModuleInput) {
        didFinish()
    }

    func moduleWantsToClose(_ input: SelectListModuleInput) {
        if rootViewController?.presentedViewController != nil || rootViewController?.presentingViewController != nil {
            rootViewController?.dismiss(animated: true, completion: nil)
        } else {
            rootViewController.map {
                _ = rootNavigationController?.popToViewController($0, animated: true)
            }
        }
    }
}
