//
//  TicketsListChipsCollectionViewCell.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 09.04.2024.
//

import UIKit

final class TicketsListChipsCollectionViewCell: UICollectionViewCell {

    // MARK: Private Properties

    enum CellState {
        case content(DisplayData)
        case loading

        struct DisplayData {
            let title: String
            let isSelected: Bool
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: .systemFont(ofSize: 14))
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()

    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            super.isSelected = newValue
            if newValue {
                backgroundColor = .primaryKFU
                titleLabel.textColor = .white
            } else if newValue == false {
                backgroundColor = .secondarySystemBackground
                titleLabel.textColor = .label
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
        contentView.isSkeletonable = true
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview().inset(4)
            $0.center.equalToSuperview()
            $0.height.equalTo(22)
        }

        contentView.layer.masksToBounds = true
        layer.cornerRadius = 16
        contentView.layer.cornerRadius = 16
    }

    func configure(state: CellState) {
        switch state {
        case let .content(displayData):
            contentView.hideSkeleton()
            titleLabel.text = displayData.title
            self.isSelected = displayData.isSelected

        case .loading:
            contentView.showSkeleton()
            titleLabel.text = "*********"
        }
    }
}
