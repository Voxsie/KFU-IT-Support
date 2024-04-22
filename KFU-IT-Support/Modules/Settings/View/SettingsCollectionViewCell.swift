//
//  SettingsCollectionViewCell.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 17.04.2024.
//

import UIKit

class SettingsCollectionViewCell: UICollectionViewCell {

    // MARK: Private Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 14))
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.numberOfLines = 2
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 12))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel, subtitleLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .top
        stackView.distribution = .fill
        return stackView
    }()

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private Properties

    private func setupView() {
        contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(0)
            $0.top.equalToSuperview().inset(0)
            $0.bottom.equalToSuperview().inset(12)
        }
        addSeparator()
    }

    func configure(with displayData: SettingsViewState.DisplayData) {
        self.titleLabel.text = displayData.title

        self.subtitleLabel.text = displayData.subtitle
        self.subtitleLabel.isHidden = displayData.subtitle == nil
    }
}
