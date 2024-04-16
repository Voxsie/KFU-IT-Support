//
//  TicketDetailsHeaderView.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 07.04.2024.
//

import UIKit
import LetterAvatarKit

final class TicketDetailsHeaderView: UICollectionReusableView {

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: .ava)
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFontMetrics.default.scaledFont(for: .boldSystemFont(ofSize: 24))
        label.adjustsFontForContentSizeCategory = true
        label.minimumScaleFactor = 0.5
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 14))
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .systemBackground

        return containerView
    }()

    private lazy var stackLabel: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        titleLabel.snp.makeConstraints {  $0.height.greaterThanOrEqualTo(20) }
        subtitleLabel.snp.makeConstraints {  $0.height.greaterThanOrEqualTo(15) }
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 15
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .secondarySystemBackground
        containerView.addSubview(stackLabel)
        stackLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(55)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }

        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(44)
            $0.leading.trailing.equalToSuperview()
        }

        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(70).priority(.required)
            $0.top.equalTo(self.snp.top).offset(12)
        }

        self.snp.makeConstraints {
            $0.bottom.equalTo(containerView.snp.bottom)
        }

        subtitleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }

    func configure(
        _ displayData: TicketDetailsViewState.TicketDetailsHeaderDisplayData
    ) {
        titleLabel.text = displayData.title
        subtitleLabel.text = displayData.subtitle

        var username: String
        if let array = displayData.subtitle?.split(separator: " "), array.count >= 2 {
            username = array.prefix(2).joined(separator: "")
        } else if let subtitle = displayData.subtitle {
            username = subtitle
        } else {
            username = ""
        }

        let circleAvatarImage = LetterAvatarMaker()
            .setCircle(true)
            .setUsername(username)
            .setLettersColor(.systemBackground)
            .build()
        imageView.image = circleAvatarImage
    }
}
