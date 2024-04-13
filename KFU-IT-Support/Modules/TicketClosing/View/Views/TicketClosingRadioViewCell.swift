//
//  TicketClosingRadioViewCell.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 12.04.2024.
//

import Foundation
import UIKit

final class TicketClosingRadioViewCell: UICollectionViewCell {

    // MARK: Private properties

    private var type: SelectListViewState.SelectType = .single

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: .ava)
        return imageView
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    private lazy var horizontalStackView: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [
        imageView,
        textLabel
       ])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()

    // MARK: Public properties

    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            super.isSelected = newValue
            if newValue {
                switch type {
                case .single:
                    imageView.image = .singleRadioSelected

                case .multi:
                    imageView.image = .multiRadioSelected
                }
            } else {
                switch type {
                case .single:
                    imageView.image = .singleRadioNotSelected

                case .multi:
                    imageView.image = .multiRadioNotSelected
                }
            }
        }
    }

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        imageView.snp.makeConstraints {
            $0.height.width.equalTo(32)
        }
    }

    func setType(
        _ type: SelectListViewState.SelectType
    ) {
        self.type = type
    }

    func configure(title: String, isSelected: Bool) {
        textLabel.text = title
        self.isSelected = isSelected
    }

    func changeValue() {
        let newValue = !isSelected
        isSelected = newValue
    }
}
