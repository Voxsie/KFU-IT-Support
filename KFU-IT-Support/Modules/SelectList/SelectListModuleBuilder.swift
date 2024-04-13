//  
//  SelectListModuleBuilder.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 12.04.2024.
//

import Foundation
import UIKit

public final class SelectListModuleBuilder {

    // MARK: Private Properties

    private weak var output: SelectListModuleOutput?

    // MARK: Lifecycle

    init(
        output: SelectListModuleOutput?
    ) {
        self.output = output
    }

    // MARK: Public Methods

    public func build() -> UIViewController {
        let interactor = SelectListInteractor()
        let presenter = SelectListPresenter(
            type: .multi,
            interactor: interactor
        )
        let viewController = SelectListViewController(output: presenter)

        presenter.view = viewController
        presenter.moduleOutput = output

        interactor.output = presenter

        return viewController
    }
}
