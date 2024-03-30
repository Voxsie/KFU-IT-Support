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
        collectionView.dataSource = self

        collectionView.register(
            TicketListCollectionViewCell.self,
            forCellWithReuseIdentifier: TicketListCollectionViewCell.reusableIdentifier
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
            heightDimension: .estimated(112)
        )
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

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
        case .display:
            return 10
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
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TicketListCollectionViewCell.reusableIdentifier,
                for: indexPath
            ) as? TicketListCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure()
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
