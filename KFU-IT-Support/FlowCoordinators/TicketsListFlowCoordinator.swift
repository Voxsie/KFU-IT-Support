//
//  TicketsFlowCoordinator.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import Swinject
import UIKit

final class TicketsListFlowCoordinator: FlowCoordinatorProtocol {

    // MARK: Private propeties

//    private var resolver: Resolver

    private weak var parentTabbarViewController: UITabBarController?

    var childFlowCoordinators: [FlowCoordinatorProtocol] = []

    init(
        parentTabbarViewController: UITabBarController
    ) {
        self.parentTabbarViewController = parentTabbarViewController
//        self.resolver = resolver
    }

    func start(animated: Bool) {
        let builder = TicketsListModuleBuilder(
            moduleOutput: self
//            resolver: resolver
        )
        let ticketsListViewController = builder.build()
        ticketsListViewController.tabBarItem = UITabBarItem(
            title: "Заявки",
            image: UIImage(),
            tag: 0
        )
        let navigationController = UINavigationController(rootViewController: ticketsListViewController)
        parentTabbarViewController?.appendViewController(
            navigationController,
            animated: false
        )
    }

    func finish(animated: Bool, completion: (() -> Void)?) {
        //
    }
}

extension TicketsListFlowCoordinator: TicketsListModuleOutput {
    func moduleDidLoad(_ module: TicketsListModuleInput) {
        //
    }
    
    func moduleDidClose(_ module: TicketsListModuleInput) {
        //
    }
}
