//
//  OfflineTitle.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 24.04.2024.
//

import UIKit

final class OfflineTitle: UIView {

    private let imageView = UIImageView(image: .offlineModeIcon)

    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(
            for: .boldSystemFont(ofSize: 16)
        )
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    private lazy var horizontalStackView: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [
        imageView,
        textLabel
       ])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()

    init(title: String, showOffline: Bool) {
        super.init(frame: .zero)

        isUserInteractionEnabled = true

        textLabel.text = title
        imageView.isHidden = !showOffline
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(horizontalStackView)
        horizontalStackView.pinToSuperview()
    }

    func updateState(isOffline: Bool) {
        imageView.isHidden = !isOffline
    }
}
