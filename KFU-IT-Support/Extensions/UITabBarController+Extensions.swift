//
//  UITabBarController+Extensions.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 30.03.2024.
//

import UIKit

extension UITabBarController {
    public func appendViewController(
        _ viewController: UIViewController,
        animated: Bool
    ) {
        if var currentViewControllers = viewControllers {
            currentViewControllers.append(viewController)
            setViewControllers(currentViewControllers, animated: animated)
        } else {
            setViewControllers([viewController], animated: animated)
        }
    }

    public func removeViewController(
        _ viewController: UIViewController,
        animated: Bool
    ) {
        guard var vcs = viewControllers else { return }
        guard let index = vcs.firstIndex(of: viewController) else { return }

        vcs.remove(at: index)
        setViewControllers(vcs, animated: animated)
    }

    public func removeAllViewControllers() {
        viewControllers = []
    }
}
