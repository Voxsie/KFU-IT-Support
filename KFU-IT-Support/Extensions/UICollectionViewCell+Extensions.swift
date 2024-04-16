//
//  UICollectionViewCell+Extensions.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 14.04.2024.
//

import UIKit

extension UICollectionViewCell {
    func addSeparator() {
        let separatorView = UIView()
        separatorView.backgroundColor = .separator
        addSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
