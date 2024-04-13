//
//  TicketClosingTextView.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 10.04.2024.
//

import Foundation
import UIKit

final class TicketClosingTextView: UIView {

    // MARK: Private properties

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 16
        textView.textContainerInset = .init(
            top: 16, left: 16, bottom: 16, right: 16
        )
        textView.font = .systemFont(ofSize: 16)
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.isEditable = true
        return textView
    }()

    private lazy var verticalStackStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            captionLabel,
            textView
        ])
         stack.axis = .vertical
         stack.spacing = 8
         stack.distribution = .fill
         stack.alignment = .leading
         return stack
     }()

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods

    func configure(
        title: String,
        textValue: String,
        didBecomeActive: () -> Void
    ) {
        captionLabel.text = title
        textView.text = textValue
    }

    // MARK: Private methods

    private func setupView() {
        addSubview(verticalStackStack)
        verticalStackStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(16)
        }

        textView.snp.makeConstraints {
            $0.height.equalTo(200)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
