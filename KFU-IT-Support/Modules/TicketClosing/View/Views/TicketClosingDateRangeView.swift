//
//  TicketClosingDateRangeView.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 10.04.2024.
//

import Foundation
import UIKit

final class TicketClosingDateRangeView: UIView {

    struct DateDisplayData {
        var value: String
        var action: () -> Void
    }

    // MARK: Private properties

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    private let startDateRangeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .secondarySystemBackground
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.setTitle("19.05.2024", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 16
        button.setContentInsets(
            .init(top: 8, left: 16, bottom: 8, right: 16)
        )
        return button
    }()

    private let betweenLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.text = "—"
        return label
    }()

    private let endDateRangeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .secondarySystemBackground
        button.titleLabel?.font = .systemFont(
            ofSize: 16,
            weight: .regular
        )
        button.setTitle("22.05.2024", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 16
        button.setContentInsets(
            .init(top: 8, left: 16, bottom: 8, right: 16)
        )
        return button
    }()

    private lazy var horizontalStackView: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [
        startDateRangeButton,
        betweenLabel,
        endDateRangeButton
       ])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()

    private lazy var verticalStackStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            captionLabel,
            horizontalStackView
        ])
        captionLabel.snp.makeConstraints {
            $0.height.equalTo(18)
        }
         stack.axis = .vertical
         stack.spacing = 8
         stack.distribution = .fill
         stack.alignment = .leading
         return stack
     }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        title: String,
        startDate: DateDisplayData,
        endDate: DateDisplayData
    ) {
        captionLabel.text = title
        startDateRangeButton.setTitle(
            startDate.value,
            for: .normal
        )

        startDateRangeButton.addAction {
            startDate.action()
        }

        endDateRangeButton.addAction {
            endDate.action()
        }
    }

    private func setupView() {
        addSubview(verticalStackStack)
        verticalStackStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(16)
        }

        startDateRangeButton.snp.makeConstraints {
            $0.height.equalTo(32)
        }

        endDateRangeButton.snp.makeConstraints {
            $0.height.equalTo(32)
        }
    }
}
