//
//  TicketsListCollectionViewCell.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 30.03.2024.
//

import UIKit

class TicketsListCollectionViewCell: UICollectionViewCell {

    // MARK: Private Properties

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(
            image: UIImage()
        )
        imageView.layer.cornerRadius = 20
        return imageView
    }()

    private lazy var ticketTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.numberOfLines = 2
        return label
    }()

    private lazy var expireSubtitle: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()

    private lazy var authorSubtitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private lazy var sectionSubtitle: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()

    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            ticketTitle, expireSubtitle
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

        addSeparator()
    }

    private func addSeparator() {
        let separatorView = UIView()
        separatorView.backgroundColor = .separator
        addSubview(separatorView)
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func makeTitle(
        boldString: String,
        normalString: String
    ) -> NSMutableAttributedString {
        let attributsBold = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            NSAttributedString.Key.backgroundColor: UIColor.secondarySystemBackground
        ]
        let attributsNormal = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)]

        let title = NSMutableAttributedString(string: boldString, attributes: attributsBold)
        let attributedString = NSMutableAttributedString(string: normalString, attributes: attributsNormal)

        title.append(attributedString)

        return title
    }

    func configure() {
        self.authorSubtitle.text = "Гумарова Ирина Ивановна (ведущий научный сотрудник, к.н."
        self.sectionSubtitle.text = """
КФУ / Институт физики/ НИЛ Компьютерный дизайн новых материалов и машинное обучениe
"""
        self.ticketTitle.attributedText = makeTitle(
            boldString: " №17234 ",
            normalString: """
            Нет доступа к почтовому ящику. у одного из сотрудников перестал работать почтовый ящик по старому \
            паролю. Пользователь skaviani (Садех Кавиани). \
            В свой личный кабинет войти он тоже не может, пароль не подходит, а сменить не может, \
так как кабинет привязан к почте КФУ, к которой также не работает пароль. Спасибо
"""
        )
        self.expireSubtitle.text = "Cрок выполнения: 17.11.2023 18:00"
        self.imageView.image = UIImage()
    }
}
