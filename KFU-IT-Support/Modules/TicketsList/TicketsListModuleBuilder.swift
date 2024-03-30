//  
//  TicketsListModuleBuilder.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import UIKit

public final class TicketsListModuleBuilder {

    // MARK: Private Properties
    
//    private let resolver: TCSResolver
    private weak var moduleOutput: TicketsListModuleOutput?

    // MARK: Lifecycle

    public init(
//        resolver: TCSResolver,
        moduleOutput: TicketsListModuleOutput?
    ) {
//        self.resolver = resolver
        self.moduleOutput = moduleOutput
    }


    // MARK: Public Methods

    public func build() -> UIViewController {
        let interactor = TicketsListInteractor()
        let presenter = TicketsListPresenter(interactor: interactor)
        let viewController = TicketsListViewController(output: presenter)
        
        presenter.view = viewController
        presenter.moduleOutput = moduleOutput

        interactor.output = presenter

        return viewController
    }
}
