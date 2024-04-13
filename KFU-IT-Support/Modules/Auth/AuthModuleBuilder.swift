//
//  AuthModuleBuilder.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 30.03.2024.
//

import UIKit

public final class AuthModuleBuilder {

    // MARK: Private Properties

    private weak var moduleOutput: AuthModuleOutput?

    // MARK: Lifecycle

    public init(
        moduleOutput: AuthModuleOutput?
    ) {
        self.moduleOutput = moduleOutput
    }

    // MARK: Public Methods

    public func build() -> UIViewController {
        let interactor = AuthInteractor()
        let presenter = AuthPresenter(interactor: interactor)
        let viewController = AuthViewController(output: presenter)

        presenter.view = viewController
        presenter.moduleOutput = moduleOutput

        interactor.output = presenter

        return viewController
    }
}
