//
//  AuthFlowCoordinator.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 30.03.2024.
//

import UIKit

protocol AuthFlowCoordinatorInput: AnyObject {}

protocol AuthFlowCoordinatorOutput: AnyObject {
    func flowCoordinatorWantsToOpenAuthorizedZone()
}

final class AuthFlowCoordinator: FlowCoordinatorProtocol {

    // MARK: Private properties

    private var windowsManager: WindowsManagerProtocol

    private var window: UIWindow?

    private let output: AuthFlowCoordinatorOutput

    private var finishHandlers: [() -> Void] = []

    private var viewController: UITabBarController?

    // MARK: Public properties

    var childFlowCoordinators: [FlowCoordinatorProtocol] = []

    // MARK: Lifecycle

    public init(
        window: UIWindow,
        windowsManager: WindowsManagerProtocol,
        output: AuthFlowCoordinatorOutput,
        finishHandler: @escaping () -> Void
    ) {
        self.window = window
        self.windowsManager = windowsManager
        self.output = output

        finishHandlers.append(finishHandler)
    }

    func start(animated: Bool) {
        let builder = AuthModuleBuilder(
            moduleOutput: self
        )
        let viewController = builder.build()

        guard let window else { return }

        windowsManager.switchViewController(
            viewController,
            in: window,
            animated: animated,
            completion: {}
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

// MARK: - AuthModuleOutput

extension AuthFlowCoordinator: AuthModuleOutput {

    func moduleUnload(_ module: AuthModuleInput) {
        didFinish()
    }

    func moduleWantsToOpenAuthorizedZone(_ module: AuthModuleInput) {
        output.flowCoordinatorWantsToOpenAuthorizedZone()
    }

    func moduleDidLoad(_ module: AuthModuleInput) {
        //
    }

    func moduleDidClose(_ module: AuthModuleInput) {
        //
    }
}
