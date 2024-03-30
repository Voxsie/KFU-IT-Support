//
//  TicketListCollectionViewCell.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 30.03.2024.
//

import UIKit

class TicketListCollectionViewCell: UICollectionViewCell {

    // MARK: Private Properties

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(
            image: UIImage()
        )
        imageView.layer.cornerRadius = 20
        return imageView
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private lazy var previousLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()

    private lazy var pricesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            priceLabel, previousLabel
        ])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .bottom
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.numberOfLines = 0

        return label
    }()

    private lazy var button: UIButton = {
        let button = UIButton()
        return button
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
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 20

        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview().inset(8)
            $0.height.equalTo(imageView.snp.width)
        }

        addSubview(pricesStackView)
        pricesStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(priceLabel.snp.bottom).offset(8)
        }

        addSubview(button)
        button.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(8)
        }
    }

    func configure() {
        self.priceLabel.text = "123"
        self.titleLabel.text = "456"
        self.imageView.image = UIImage()
    }
}

