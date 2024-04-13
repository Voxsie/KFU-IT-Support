//
//  UIButton+Extentions.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 10.04.2024.
//

import UIKit

extension UIButton {
    func setContentInsets(_ insets: UIEdgeInsets) {
        if #available(iOS 13.0, *) {
            contentHorizontalAlignment = .center
            contentVerticalAlignment = .center
            contentEdgeInsets = insets
        } else {
            contentHorizontalAlignment = .left
            contentVerticalAlignment = .center
            titleEdgeInsets = UIEdgeInsets(top: insets.top, left: insets.left + layoutMargins.left, bottom: insets.bottom, right: insets.right + layoutMargins.right)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: -insets.left + layoutMargins.left, bottom: 0, right: -insets.right + layoutMargins.right)
        }
    }
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        @objc class ClosureSleeve: NSObject {
            let closure:()->()
            init(_ closure: @escaping()->()) { self.closure = closure }
            @objc func invoke() { closure() }
        }
        let sleeve = ClosureSleeve(closure)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}
