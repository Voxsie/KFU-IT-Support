//
//  NavigationFlow.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import UIKit

@frozen public enum NavigationFlow {
    case present(Weak<UIViewController>)
    case push(Weak<UINavigationController>)

    var isPushed: Bool {
        switch self {
        case .present:
            return false

        case .push:
            return true
        }
    }

    var isPresented: Bool {
        switch self {
        case .present:
            return true

        case .push:
            return false
        }
    }
}
