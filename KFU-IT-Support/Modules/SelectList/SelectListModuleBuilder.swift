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

    private let title: String
    private let items: [SelectListViewState.DisplayData]
    private let type: SelectListViewState.SelectType

    // MARK: Lifecycle

    init(
        output: SelectListModuleOutput?,
        title: String,
        items: [SelectListViewState.DisplayData],
        type: SelectListViewState.SelectType
    ) {
        self.output = output
        self.title = title
        self.items = items
        self.type = type
    }

    // MARK: Public Methods

    public func build() -> UIViewController {
        let interactor = SelectListInteractor()
        let presenter = SelectListPresenter(
            type: type,
            items: items,
            interactor: interactor
        )
        let viewController = SelectListViewController(output: presenter)
        viewController.configure(title: title)

        presenter.view = viewController
        presenter.moduleOutput = output

        interactor.output = presenter

        return viewController
    }
}
