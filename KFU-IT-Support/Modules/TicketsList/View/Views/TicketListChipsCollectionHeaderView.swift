//
//  TicketsListChipsCollectionView.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 09.04.2024.
//

import Foundation
import UIKit

protocol TicketsListChipsCollectionHeaderViewDelegate: AnyObject {
    func didSelectItem(_ type: TicketsListViewState.FilterType)
}

final class TicketsListChipsCollectionHeaderView: UICollectionReusableView {

    // MARK: Private properties

    private var items: [TicketsListViewState.ChipsDetailsData] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: UICollectionViewCell.reusableIdentifier
        )
        collectionView.register(
            TicketsListChipsCollectionViewCell.self,
            forCellWithReuseIdentifier: TicketsListChipsCollectionViewCell.reusableIdentifier
        )
        return collectionView
    }()

    weak var delegate: TicketsListChipsCollectionHeaderViewDelegate?

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods

    func configure(_ items: [TicketsListViewState.ChipsDetailsData]) {
        print(items)
        self.items = items
    }

    // MARK: Private methods

    private func setupView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {

        let itemsInsets = NSDirectionalEdgeInsets.zero

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = itemsInsets

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .fractionalHeight(1)
        )

        let groupInsets = NSDirectionalEdgeInsets.zero

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        group.contentInsets = groupInsets

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 8,
            leading: 16,
            bottom: 8,
            trailing: 16
        )
        section.interGroupSpacing = 12

        section.orthogonalScrollingBehavior = .continuous

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
}

extension TicketsListChipsCollectionHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        guard
            let item = items[safe: indexPath.row],
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TicketsListChipsCollectionViewCell.reusableIdentifier,
                for: indexPath
            ) as? TicketsListChipsCollectionViewCell
        else { return collectionView.dequeueReusableCell(
            withReuseIdentifier: UICollectionViewCell.reusableIdentifier,
            for: indexPath
        )}

        cell.configure(
            title: item.title,
            isSelected: item.isSelected
        )

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = items[safe: indexPath.row] else { return }

        collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
        delegate.mapOrLog { $0.didSelectItem(item.type) }
    }
}
