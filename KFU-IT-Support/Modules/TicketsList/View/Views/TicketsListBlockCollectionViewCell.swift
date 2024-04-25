//
//  TicketsListBlockCollectionViewCell.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 23.04.2024.
//

import UIKit
import SkeletonView

class TicketsListBlockCollectionViewCell: UICollectionViewCell {

    // MARK: Private Properties

    private lazy var blockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.Icons.errorView.image
        return imageView
    }()

    private lazy var blockTitle: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: .boldSystemFont(ofSize: 16))
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.text = "Ошибка"
        label.textAlignment = .center
        return label
    }()

    private lazy var blockSubtitle: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 13))
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.text = "Попробуйте еще раз"
        label.textAlignment = .center
        return label
    }()

    private lazy var firstButton: Button = {
        let firstButton = Button()
        firstButton.setTitle("Повторить", for: .normal)
        firstButton.titleLabel?.font = .systemFont(ofSize: 13)
        firstButton.isUserInteractionEnabled = true
        return firstButton
    }()

    private lazy var secondButton: Button = {
        let secondButton = Button()
        secondButton.setTitle("Повторить", for: .normal)
        secondButton.setTitleColor(UIColor.primaryKFU, for: .normal)
        secondButton.titleLabel?.font = .systemFont(ofSize: 13)
        secondButton.isUserInteractionEnabled = true
        secondButton.backgroundColor = .systemBackground
        secondButton.layer.borderWidth = 1
        secondButton.layer.borderColor = UIColor.primaryKFU.cgColor
        return secondButton
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            blockTitle, blockSubtitle
        ])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            firstButton, secondButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            blockImageView, textStackView, buttonStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
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
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.centerY.equalToSuperview().offset(-100)
        }

        blockImageView.snp.makeConstraints {
            $0.height.width.equalTo(128)
        }

        firstButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(150)
        }

        secondButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(150)
        }
    }

    func configure(with displayData: TicketsListViewState.ErrorDisplayData) {
        blockImageView.image = displayData.image
        blockTitle.text = displayData.title
        blockSubtitle.text = displayData.subtitle

        firstButton.isHidden = displayData.firstButton == nil
        firstButton.setTitle(displayData.firstButton?.buttonTitle, for: .normal)
        firstButton.addAction {
            displayData.firstButton?.action()
        }

        secondButton.isHidden = displayData.secondButton == nil
        secondButton.setTitle(displayData.secondButton?.buttonTitle, for: .normal)
        secondButton.addAction {
            displayData.secondButton?.action()
        }
    }
}
