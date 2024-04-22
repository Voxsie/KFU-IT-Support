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

    private let uuid: String

    // MARK: Lifecycle

    public init(
        moduleOutput: TicketDetailsModuleOutput?,
        uuid: String
    ) {
        self.moduleOutput = moduleOutput
        self.uuid = uuid
    }

    // MARK: Public Methods

    public func build() -> UIViewController {
        let repository = Repository()
        let interactor = TicketDetailsInteractor(repository: repository)
        let presenter = TicketDetailsPresenter(
            interactor: interactor,
            uuid: uuid
        )
        let viewController = TicketDetailsViewController(output: presenter)

        presenter.view = viewController
        presenter.moduleOutput = moduleOutput

        interactor.output = presenter

        return viewController
    }
}
