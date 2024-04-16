//
//  TicketsListCollectionViewCell.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 30.03.2024.
//

import UIKit

class TicketsListCollectionViewCell: UICollectionViewCell {

    // MARK: Private Properties

    private lazy var capsuleView = CapsuleView()

    private lazy var ticketTitle: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: .boldSystemFont(ofSize: 16))
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.numberOfLines = 2
        return label
    }()

    private lazy var expireSubtitle: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFontMetrics.default.scaledFont(for: .boldSystemFont(ofSize: 13))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private lazy var authorSubtitle: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: .boldSystemFont(ofSize: 13))
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private lazy var sectionSubtitle: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFontMetrics.default.scaledFont(for: .boldSystemFont(ofSize: 13))
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            capsuleView, ticketTitle, expireSubtitle
        ])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .top
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            authorSubtitle, sectionSubtitle
        ])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            topStackView, bottomStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
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
        addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(0)
            $0.top.equalToSuperview().inset(0)
            $0.bottom.equalToSuperview().inset(12)
        }

        capsuleView.snp.makeConstraints { make in
            make.height.equalTo(30)
        }

        addSeparator()
    }

    func configure(with displayData: TicketsListViewState.ShortDisplayData) {
        self.capsuleView.setText(displayData.id)
        self.authorSubtitle.text = displayData.author
        self.sectionSubtitle.text = displayData.authorSection
        self.ticketTitle.text = displayData.ticketText
        self.expireSubtitle.text = displayData.expireText

        switch displayData.type {
        case .okay:
            capsuleView.setBackgroundColor(.primaryKFU)

        case .expired:
            capsuleView.setBackgroundColor(.red)

        case .completed:
            capsuleView.setBackgroundColor(.green)
        }
    }
}
