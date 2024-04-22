//  
//  TicketClosingModuleBuilder.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 08.04.2024.
//

import Foundation
import UIKit

public final class TicketClosingModuleBuilder {

    // MARK: Private Properties

    private weak var output: TicketClosingModuleOutput?

    private let ticketID: String

    // MARK: Lifecycle

    init(
        ticketID: String,
        output: TicketClosingModuleOutput?
    ) {
        self.ticketID = ticketID
        self.output = output
    }

    // MARK: Public Methods

    public func build() -> UIViewController {
        let repository = Repository()
        let interactor = TicketClosingInteractor(repository: repository)
        let presenter = TicketClosingPresenter(
            ticketID: ticketID,
            interactor: interactor
        )
        let viewController = TicketClosingViewController(output: presenter)

        presenter.view = viewController
        presenter.moduleOutput = output

        interactor.output = presenter

        return viewController
    }
}
