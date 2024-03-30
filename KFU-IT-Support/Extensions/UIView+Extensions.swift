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

