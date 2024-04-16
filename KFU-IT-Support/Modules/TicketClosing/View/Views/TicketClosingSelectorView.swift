//
//  TicketClosingRadioListView.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 12.04.2024.
//

import UIKit

final class TicketClosingSelectorView: UIView {

    struct DisplayData {
        var id: Int
        var title: String
        var isSelected: Bool
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

    private let selector: Selector = {
        let selector = Selector()
        return selector
    }()

    private lazy var contentStackStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            captionLabel,
            selector
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
        value: String? = nil
    ) {
        captionLabel.text = title
        selector.setTitle(value, for: .normal)
    }

    func addAction(_ action: @escaping () -> Void) {
        selector.addAction { action() }
    }

    // MARK: Private methods

    private func setupView() {
        addSubview(contentStackStack)
        contentStackStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(8)
        }

        selector.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(0)
        }
    }

    func getTitle() -> String {
        selector.titleLabel?.text ?? ""
    }

    func getValues() -> [Bool] {
        [true]
    }
}
