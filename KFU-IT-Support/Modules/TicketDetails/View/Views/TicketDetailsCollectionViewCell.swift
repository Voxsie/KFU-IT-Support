//
//  TicketDetailsCollectionViewCell.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 07.04.2024.
//

import Foundation
import UIKit

final class TicketDetailsCollectionViewCell:
    UICollectionViewCell {

    // MARK: Private properties

    enum CornerRadiusType {
        case firstCell
        case middleCell
        case lastCell
    }

    private var url: URL?

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 12))
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let sectionTitle: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: .boldSystemFont(ofSize: 16))
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.text = "Подробности"
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 14))
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var stackView: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [valueLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fill
        stack.alignment = .leading
        return stack
    }()

    private lazy var generalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [captionLabel])
        captionLabel.snp.makeConstraints {
            $0.height.equalTo(18)
        }
         stack.axis = .vertical
         stack.spacing = 20
         stack.distribution = .fill
         stack.alignment = .leading
         return stack
     }()

    override func prepareForReuse() {
        super.prepareForReuse()
        sectionTitle.removeFromSuperview()
    }

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor = .systemBackground
        contentView.addSubview(generalStack)
        generalStack.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.top.equalTo(contentView.snp.top).offset(14)
        }
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.equalTo(captionLabel.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
            $0.top.equalTo(captionLabel.snp.bottom).offset(4)
            $0.bottom.equalTo(contentView.snp.bottom).inset(10)
        }
    }

    // MARK: Public methods

    func setCornerRadius(_ cornerRadiusType: CornerRadiusType) {
        switch cornerRadiusType {
        case .firstCell:
            layer.cornerRadius = 10.0
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            addSeparator()

        case .middleCell:
            layer.cornerRadius = 0.0
            addSeparator()

        case .lastCell:
            layer.cornerRadius = 10.0
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }

    func configure(
        _ displayData: TicketDetailsViewState.TicketDetailsCellDisplayData
    ) {
        if displayData.order == 0 {
            generalStack.insertArrangedSubview(sectionTitle, at: 0)
        }
        captionLabel.text = displayData.caption

        if case let .hyperlink(link) = displayData.contentType {
            self.url = link
            let attributes: [NSAttributedString.Key: Any] = [
                .link: link ?? URL(string: "https://google.com")!,
                .foregroundColor: UIColor.blue,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]

            // Создание NSAttributedString с гиперссылкой
            let attributedString = NSAttributedString(
                string: displayData.value,
                attributes: attributes
            )

            valueLabel.attributedText = attributedString
            valueLabel.isUserInteractionEnabled = true

            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(handleLinkTap)
            )
            valueLabel.addGestureRecognizer(tapGesture)

        } else {
            valueLabel.text = displayData.value
            valueLabel.isUserInteractionEnabled = false

            valueLabel.gestureRecognizers?.removeAll()
        }
    }

    @objc func handleLinkTap() {
        guard let url else { return }
        UIApplication.shared.open(url)
    }
}
