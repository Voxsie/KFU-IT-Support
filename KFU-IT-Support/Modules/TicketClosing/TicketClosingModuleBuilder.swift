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

    // MARK: Lifecycle

    init(
        output: TicketClosingModuleOutput?
    ) {
        self.output = output
    }


    // MARK: Public Methods

    public func build() -> UIViewController {
        let interactor = TicketClosingInteractor()
        let presenter = TicketClosingPresenter(interactor: interactor)
        let viewController = TicketClosingViewController(output: presenter)
        
        presenter.view = viewController
        presenter.moduleOutput = output

        interactor.output = presenter

        return viewController
    }
}
