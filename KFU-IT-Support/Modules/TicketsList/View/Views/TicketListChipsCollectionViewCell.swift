//
//  TicketListChipsCollectionViewCell.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 09.04.2024.
//

import UIKit

final class TicketListChipsCollectionViewCell: UICollectionViewCell {

    // MARK: Private Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 14))
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            super.isSelected = newValue
            if newValue {
                backgroundColor = .primaryKFU
                titleLabel.textColor = .white
            } else if newValue == false {
                backgroundColor = .secondarySystemBackground
                titleLabel.textColor = .label
            }
        }
    }

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview().inset(4)
            $0.center.equalToSuperview()
            $0.height.equalTo(22)
        }

        layer.cornerRadius = 16
    }

    func configure(
        title: String,
        isSelected: Bool
    ) {
        self.isSelected = isSelected
        titleLabel.text = title
    }
}
