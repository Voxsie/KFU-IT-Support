//
//  TicketDetailsViewController.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 07.04.2024.
//

import UIKit
import SnapKit

final class TicketDetailsViewController: UIViewController {

    // MARK: Private data structures

    private enum Constants {
        static let settingsTitle = "Заявка"
    }

    // MARK: Public Properties

    // MARK: Private Properties

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createCollectionViewLayout()
        )
        collectionView.register(
            TicketDetailsHeaderView.self,
            forSupplementaryViewOfKind:  UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TicketDetailsHeaderView.reusableIdentifier
        )
        collectionView.register(
            TicketDetailsCollectionViewCell.self, 
            forCellWithReuseIdentifier: TicketDetailsCollectionViewCell.reusableIdentifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.backgroundColor = .secondarySystemBackground

        return collectionView
    }()

    private let output: TicketDetailsViewOutput

    // MARK: Lifecycle

    init(output: TicketDetailsViewOutput) {
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
        view.backgroundColor = .secondarySystemBackground
        navigationItem.title = Constants.settingsTitle

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Закрыть",
            style: .plain,
            target: self,
            action: #selector(didLeftButtonPressed)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Дополнить",
            style: .plain,
            target: self,
            action: #selector(didRightButtonPressed)
        )

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }


    @objc
    private func didLeftButtonPressed() {
        output.viewDidTapCloseButton()
    }

    @objc
    private func didRightButtonPressed() {
        output.viewDidTapCloseTicket()
    }
}

// MARK: - TicketDetailsViewInput

extension TicketDetailsViewController: TicketDetailsViewInput {}

// MARK: UICollectionViewCompositionalLayout

private extension TicketDetailsViewController {
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {

        let spacing: CGFloat = 16

        let itemsInsets = NSDirectionalEdgeInsets.zero

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(30)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = itemsInsets

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(30)
        )

        let groupInsets = NSDirectionalEdgeInsets.zero

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        group.contentInsets = groupInsets

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: spacing,
            leading: spacing,
            bottom: spacing,
            trailing: spacing
        )
        section.interGroupSpacing = .zero

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(112)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]

        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension TicketDetailsViewController:
    UICollectionViewDelegate,
    UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let state = output.getState()

        switch state {
        case .display:
            return state.details?.count ?? 0

        default:
            return 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let state = output.getState()

        guard let displayData = state.details,
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TicketDetailsCollectionViewCell.reusableIdentifier,
                for: indexPath
              ) as? TicketDetailsCollectionViewCell
        else { return UICollectionViewCell() }

        cell.configure(displayData[indexPath.row])

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {

        let state = output.getState()

        guard let headerDisplayData = state.header,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TicketDetailsHeaderView.reusableIdentifier,
                for: indexPath
              ) as? TicketDetailsHeaderView
        else { return UICollectionReusableView() }

        header.configure(headerDisplayData)

        return header
    }
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

