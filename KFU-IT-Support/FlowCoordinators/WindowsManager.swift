//
//  WindowsManager.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import Foundation
import UIKit

protocol WindowsManagerProtocol {
    func switchViewController(
        _ viewController: UIViewController,
        in window: UIWindow,
        animated: Bool,
        completion: @escaping() -> Void
    )
}

final class WindowsManager: WindowsManagerProtocol {

    func switchViewController(
        _ viewController: UIViewController,
        in window: UIWindow,
        animated: Bool,
        completion: @escaping () -> Void
    ) {
        let hoveringViews = window.subviews.filter {
            $0 !== window.rootViewController?.view &&
            !$0.frame.contains(window.bounds)
        }
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        for hoveringView in hoveringViews {
            window.addSubview(hoveringView)
        }

        if animated {
            UIView.transition(
                with: window,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: nil
            ) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}

