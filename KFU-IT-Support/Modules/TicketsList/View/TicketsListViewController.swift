//  
//  TicketsListViewController.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import UIKit
import SnapKit

final class TicketsListViewController: UIViewController {

    // MARK: Private data structures

    private enum Constants {
        static let ticketsTitle = "Заявки"
    }

    // MARK: Public Properties

    // MARK: Private Properties

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createCollectionViewLayout()
        )
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(
            TicketsListCollectionViewCell.self,
            forCellWithReuseIdentifier: TicketsListCollectionViewCell.reusableIdentifier
        )
        collectionView.register(
            TicketListChipsCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TicketListChipsCollectionHeaderView.reusableIdentifier
        )

        return collectionView
    }()

    private let output: TicketsListViewOutput

    // MARK: Lifecycle

    init(output: TicketsListViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        output.viewDidUnloadEvent()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        output.viewDidLoadEvent()
    }

    // MARK: Actions

    // MARK: Private methods

    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = Constants.ticketsTitle

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}

// MARK: - TicketsListViewInput

extension TicketsListViewController: TicketsListViewInput {

}

// MARK: UICollectionViewCompositionalLayout

private extension TicketsListViewController {
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {

        let spacing: CGFloat = 16

        let itemsInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 8, bottom: 0, trailing: 8
        )

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(200)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = itemsInsets

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(200)
        )

        let groupInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 8, bottom: 0, trailing: 8
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        group.contentInsets = groupInsets

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: spacing,
            leading: 0,
            bottom: spacing,
            trailing: 0
        )
        section.interGroupSpacing = spacing

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(46)
        )

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension TicketsListViewController:
    UICollectionViewDelegate,
    UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let state = output.getState()

        switch state {
        case let .display(items):
            return items.count
        default:
            return 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let state = output.getState()

        switch state {
        case .display:
            guard
                let item = state.displayData?[safe: indexPath.row],
                let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TicketsListCollectionViewCell.reusableIdentifier,
                for: indexPath
            ) as? TicketsListCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: item)
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        output.viewDidSelectItem()
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {

        let state = output.getState()

        guard
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TicketListChipsCollectionHeaderView.reusableIdentifier,
                for: indexPath
              ) as? TicketListChipsCollectionHeaderView
        else { return UICollectionReusableView() }

//        header.configure(headerDisplayData)

        return header
    }
}
