//
//  UIViewController+Extension.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 01.04.2024.
//

import UIKit

extension UIViewController {

    func observeKeyboardTappingAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func dismissIfPresenting(animated: Bool, completion: (() -> Void)? = nil) {
        if let presentedViewController, !presentedViewController.isBeingDismissed {
            dismiss(animated: animated) {
                completion?()
            }
        } else {
            completion?()
        }
    }
}
