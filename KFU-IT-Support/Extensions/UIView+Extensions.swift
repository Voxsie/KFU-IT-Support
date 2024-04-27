//
//  UIView+Extensions.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 30.03.2024.
//

import UIKit
import SnapKit

extension UIView {
    static var reusableIdentifier: String {
        return String(describing: Self.self)
    }

    func pinToSuperview(inset: Int = 0) {
        self.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(inset)
        }
    }
}

extension UIView {
    public func findByAccessibilityIdentifier(identifier: String) -> UIView? {

        guard let window = UIApplication.shared.keyWindow else {
            return nil
        }

        func findByID(view: UIView, _ id: String) -> UIView? {
            if view.accessibilityIdentifier == id { return view }
            for subview in view.subviews {
                if let found = findByID(view: subview, id) { return found }
            }
            return nil
        }

        return findByID(view: window, identifier)
    }
}

extension UIView {
    func addActionByTarget(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping () -> Void) {
        @objc class ClosureSleeve: NSObject {
            let closure: () -> Void
            init(_ closure: @escaping() -> Void) { self.closure = closure }
            @objc func invoke() { closure() }
        }
        let sleeve = ClosureSleeve(closure)
        let tapGestureRecognizer = UITapGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        addGestureRecognizer(tapGestureRecognizer)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, .OBJC_ASSOCIATION_RETAIN)
    }
}
