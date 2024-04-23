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
            TicketsListChipsCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TicketsListChipsCollectionHeaderView.reusableIdentifier
        )
        collectionView.register(
            TicketsListEmptyHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TicketsListEmptyHeaderView.reusableIdentifier
        )
        collectionView.register(
            TicketsListBlockCollectionViewCell.self,
            forCellWithReuseIdentifier: TicketsListBlockCollectionViewCell.reusableIdentifier
        )
        return collectionView
    }()

    private let output: TicketsListViewOutput

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(didPullToRefresh),
            for: .valueChanged
        )
        return refreshControl
    }()

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
        collectionView.refreshControl = refreshControl
    }

    @objc private func didPullToRefresh() {
        output.viewDidPullToRefresh()
    }
}

// MARK: - TicketsListViewInput

extension TicketsListViewController: TicketsListViewInput {

    func finishUpdating() {
        refreshControl.endRefreshing()
    }

    func updateView() {
        let state = output.getState()
        switch state {
        case .loading, .display:
            collectionView.collectionViewLayout = createCollectionViewLayout()

        case .error:
            collectionView.collectionViewLayout = createFullscreenLayout()
        }

        collectionView.reloadData()
    }
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

    func createFullscreenLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        let section = NSCollectionLayoutSection(group: group)

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
        case let .display(_, items):
            return items.count

        case .loading:
            return 10

        case .error:
            return 1
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
            cell.configure(with: .content(item))
            collectionView.isScrollEnabled = true
            collectionView.isUserInteractionEnabled = true
            return cell

        case .loading:
            guard
                let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TicketsListCollectionViewCell.reusableIdentifier,
                for: indexPath
            ) as? TicketsListCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: .loading)
            collectionView.isScrollEnabled = false
            collectionView.isUserInteractionEnabled = false
            return cell

        case let .error(displayData):
            guard
                let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TicketsListBlockCollectionViewCell.reusableIdentifier,
                for: indexPath
            ) as? TicketsListBlockCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: displayData)
            collectionView.isScrollEnabled = false
            collectionView.isUserInteractionEnabled = true
            return cell
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        output.viewDidSelectItem(index: indexPath.row)
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
                withReuseIdentifier: TicketsListChipsCollectionHeaderView.reusableIdentifier,
                for: indexPath
            ) as? TicketsListChipsCollectionHeaderView
        else {
            return collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TicketsListEmptyHeaderView.reusableIdentifier,
                for: indexPath
            )
        }

        switch state {
        case .loading:
            header.configure(state: .loading)

        case let .display(filters, _):
            header.configure(state: .content(filters))

        case .error:
            break
        }
        header.delegate = self

        return header
    }
}

// MARK: - TicketsListChipsCollectionHeaderViewDelegate

extension TicketsListViewController: TicketsListChipsCollectionHeaderDelegate {
    func didSelectItem(_ type: TicketsListViewState.FilterType) {
        output.viewDidSelectFilterItem(type)
    }
}
