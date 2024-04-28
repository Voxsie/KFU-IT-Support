//
//  TicketsListCollectionViewCell.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 30.03.2024.
//

import UIKit
import SkeletonView

class TicketsListCollectionViewCell: UICollectionViewCell {

    // MARK: Private Properties

    enum CellState {
        case loading
        case content(TicketsListViewState.ShortDisplayData)
    }

    private var uuid: String?

    private lazy var capsuleView: CapsuleView = {
        let capsuleView = CapsuleView()
        capsuleView.isSkeletonable = true
        capsuleView.isHiddenWhenSkeletonIsActive = true
        return capsuleView
    }()

    private lazy var ticketTitle: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: .boldSystemFont(ofSize: 16))
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 2
        label.isSkeletonable = true
        label.skeletonTextNumberOfLines = 2
        label.skeletonLineSpacing = 4
        label.lastLineFillPercent = 30
        label.linesCornerRadius = 8
        return label
    }()

    private lazy var expireSubtitle: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFontMetrics.default.scaledFont(for: .boldSystemFont(ofSize: 13))
        label.adjustsFontForContentSizeCategory = true
        label.isSkeletonable = true
        label.linesCornerRadius = 8
        return label
    }()

    private lazy var authorSubtitle: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: .boldSystemFont(ofSize: 13))
        label.adjustsFontForContentSizeCategory = true
        label.isSkeletonable = true
        label.linesCornerRadius = 8
        return label
    }()

    private lazy var sectionSubtitle: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFontMetrics.default.scaledFont(for: .boldSystemFont(ofSize: 13))
        label.adjustsFontForContentSizeCategory = true
        label.isSkeletonable = true
        label.linesCornerRadius = 8
        return label
    }()

    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            capsuleView, ticketTitle, expireSubtitle
        ])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.isSkeletonable = true
        return stackView
    }()

    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            authorSubtitle, sectionSubtitle
        ])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.isSkeletonable = true
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            topStackView, bottomStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.isSkeletonable = true
        return stackView
    }()

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutSkeletonIfNeeded()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private Properties

    private func setupView() {
        contentView.isSkeletonable = true
        contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(0)
            $0.top.equalToSuperview().inset(0)
            $0.bottom.equalToSuperview().inset(12)
        }

        topStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }

        expireSubtitle.snp.makeConstraints {
            $0.height.equalTo(18)
        }

        ticketTitle.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }

        capsuleView.snp.makeConstraints { make in
            make.height.equalTo(30)
        }

        addSeparator()
    }

    func configure(with state: CellState) {
        switch state {
        case .loading:
            let animation = GradientDirection.leftRight.slidingAnimation()
            self.capsuleView.setText("***********")
            self.ticketTitle.text = "***********************"
            self.expireSubtitle.text = "************"
            self.authorSubtitle.text = "************"
            self.sectionSubtitle.text = "********"
            self.contentView.showAnimatedGradientSkeleton(
                usingGradient: .init(baseColor: .tertiarySystemFill),
                animation: animation
            )

        case let .content(displayData):
            contentView.hideSkeleton()

            self.uuid = displayData.uuid
            if let id = displayData.id {
                self.capsuleView.setText(id)
            }
            self.capsuleView.isHidden = displayData.id == nil
            self.authorSubtitle.text = displayData.author
            self.sectionSubtitle.text = displayData.authorSection
            self.ticketTitle.text = displayData.ticketText
            self.expireSubtitle.text = displayData.expireText

            switch displayData.type {
            case .okay:
                capsuleView.setBackgroundColor(.primaryKFU)

            case .expired:
                capsuleView.setBackgroundColor(.red)

            case .completed:
                capsuleView.setBackgroundColor(.green)

            case .hot:
                capsuleView.setBackgroundColor(.primaryDarkRed)
            }
        }
    }
}
