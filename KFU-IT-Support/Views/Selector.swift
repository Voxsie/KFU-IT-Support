//
//  Selector.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 13.04.2024.
//

import UIKit

final class Selector: UIButton {

    // MARK: Lifecycle

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.cornerRadius = 10
        backgroundColor = .clear
        layer.borderColor = UIColor.separator.cgColor
        layer.borderWidth = 1
        setTitleColor(.label, for: .normal)
        contentHorizontalAlignment = .leading
        titleLabel?.font = .systemFont(ofSize: 14)
        setTitle("Частично, Полностью", for: .normal)

        addRightImage(image: .arrowDown, offset: 12)

        snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }
}

extension UIButton {
    func addRightImage(
        image: UIImage,
        offset: CGFloat
    ) {
        self.setImage(svgImage(image: image, width: 16, height: 16), for: .normal)
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        self.imageView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -offset).isActive = true
    }
}
