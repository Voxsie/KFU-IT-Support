//
//  SettingsModuleBuilder.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 06.04.2024.
//

import UIKit

public final class SettingsModuleBuilder {

    // MARK: Private Properties

    private weak var moduleOutput: SettingsModuleOutput?

    // MARK: Lifecycle

    public init(
        moduleOutput: SettingsModuleOutput?
    ) {
        self.moduleOutput = moduleOutput
    }


    // MARK: Public Methods

    public func build() -> UIViewController {
        let interactor = SettingsInteractor()
        let presenter = SettingsPresenter(interactor: interactor)
        let viewController = SettingsViewController(output: presenter)

        presenter.view = viewController
        presenter.moduleOutput = moduleOutput

        interactor.output = presenter

        return viewController
    }
}
