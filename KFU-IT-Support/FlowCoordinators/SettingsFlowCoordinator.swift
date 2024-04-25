//
//  SettingsFlowCoordinator.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 06.04.2024.

import Swinject
import UIKit

protocol SettingsFlowCoordinatorInput: AnyObject {}

protocol SettingsFlowCoordinatorOutput: AuthrozitionFlowCoordinatorProtocol {}

final class SettingsFlowCoordinator: FlowCoordinatorProtocol {

    // MARK: Private propeties

    private var parentTabbarViewController: UITabBarController?

    private let output: SettingsFlowCoordinatorOutput

    private var finishHandlers: [() -> Void] = []

    private weak var rootViewController: UIViewController?
    private weak var rootNavigationController: UINavigationController?

    // MARK: Public properties

    var childFlowCoordinators: [FlowCoordinatorProtocol] = []

    // MARK: Lifecycle

    init(
        parentTabbarViewController: UITabBarController,
        output: SettingsFlowCoordinatorOutput,
        finishHandler: @escaping () -> Void
    ) {
        self.parentTabbarViewController = parentTabbarViewController
        self.output = output

        finishHandlers.append(finishHandler)
    }

    func start(animated: Bool) {
        let builder = SettingsModuleBuilder(
            moduleOutput: self
        )
        let settingsViewController = builder.build()
        settingsViewController.tabBarItem = UITabBarItem(
            title: "Настройки",
            image: UIImage(systemName: "gear"),
            tag: 1
        )
        let navigationController = UINavigationController(rootViewController: settingsViewController)
        rootViewController = settingsViewController
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

// MARK: - SettingsModuleOutput

extension SettingsFlowCoordinator: SettingsModuleOutput {

    func moduleUnload(_ module: SettingsModuleInput) {
        didFinish()
    }

    func moduleWantsToDeauthorize(_ module: SettingsModuleInput) {
        output.flowCoordinatorWantsToOpenUnathorizedZone()
    }
}
