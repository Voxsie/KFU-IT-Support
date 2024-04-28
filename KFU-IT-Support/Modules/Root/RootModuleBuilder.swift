//
//  RootModuleBuilder.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 28.04.2024.
//

import UIKit

public final class RootModuleBuilder {

    // MARK: Private Properties

    private weak var moduleOutput: RootModuleOutput?

    // MARK: Lifecycle

    public init(
        moduleOutput: RootModuleOutput?
    ) {
        self.moduleOutput = moduleOutput
    }

    // MARK: Public Methods

    public func build() -> UIViewController {
        let repository = Repository()
        let interactor = RootInteractor(repository: repository)
        let presenter = RootPresenter(
            interactor: interactor
        )
        let viewController = RootViewController(output: presenter)

        presenter.view = viewController
        presenter.moduleOutput = moduleOutput

        interactor.output = presenter

        return viewController
    }
}
