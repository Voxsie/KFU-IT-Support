//
//  UploadFile.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 13.04.2024.
//

import UIKit

final class UploadFile: UIView {

    // MARK: Lifecycle

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .label
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Форматы доступные для загрузки:\n .jpg, .jpeg, .png, .pdf"
        return label
    }()

    private let uploadFileButton: Button = {
        let button = Button()
        button.setTitle("Выберите файл", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 10
        return button
    }()

    private let fileLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Файл не выбран"
        return label
    }()

    private lazy var contentStackStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            uploadFileButton,
            fileLabel
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.cornerRadius = 10
        backgroundColor = .secondarySystemBackground
        snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(120)
        }

        addSubview(contentStackStack)
        contentStackStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }

        uploadFileButton.snp.makeConstraints {
            $0.width.equalTo(120)
        }
    }

    // MARK: Actions

    @objc private func didUploadButtonPressed() {

    }

    // MARK: Public methods

    func configure(
        action: () -> Void,
        fileName: String = "Файл не выбран"
    ) {

    }
}
