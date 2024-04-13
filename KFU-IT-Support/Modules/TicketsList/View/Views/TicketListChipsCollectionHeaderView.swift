//
//  TicketListChipsCollectionView.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 09.04.2024.
//

import Foundation
import UIKit

final class TicketListChipsCollectionHeaderView: UICollectionReusableView {

    // MARK: Private properties

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(
            TicketListChipsCollectionViewCell.self,
            forCellWithReuseIdentifier: TicketListChipsCollectionViewCell.reusableIdentifier
        )
        return collectionView
    }()

    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

extension TicketListChipsCollectionHeaderView: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 10
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TicketListChipsCollectionViewCell.reusableIdentifier,
            for: indexPath
        ) as? TicketListChipsCollectionViewCell
        else { return UICollectionViewCell() }

        cell.configure(
            title: indexPath.row == 0 ? "Все" : "Недавно созданные",
            isSelected: indexPath.row == 0
        )

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }
}
