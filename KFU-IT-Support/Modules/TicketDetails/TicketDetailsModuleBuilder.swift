//
//  TicketDetailsModuleBuilder.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 07.04.2024.
//

import UIKit

public final class TicketDetailsModuleBuilder {

    // MARK: Private Properties

    private weak var moduleOutput: TicketDetailsModuleOutput?

    // MARK: Lifecycle

    public init(
        moduleOutput: TicketDetailsModuleOutput?
    ) {
        self.moduleOutput = moduleOutput
    }

    // MARK: Public Methods

    public func build() -> UIViewController {
        let interactor = TicketDetailsInteractor()
        let presenter = TicketDetailsPresenter(interactor: interactor)
        let viewController = TicketDetailsViewController(output: presenter)

        presenter.view = viewController
        presenter.moduleOutput = moduleOutput

        interactor.output = presenter

        return viewController
    }
}
