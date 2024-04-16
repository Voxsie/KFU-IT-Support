//  
//  SelectListViewController.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 12.04.2024.
//

import UIKit

final class SelectListViewController: UIViewController {

    // MARK: Private data structures

    private enum Constants {

    }

    // MARK: Public Properties

    // MARK: Private Properties

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createCollectionViewLayout()
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            SelectListRadioViewCell.self,
            forCellWithReuseIdentifier: SelectListRadioViewCell.reusableIdentifier
        )
        return collectionView
    }()

    private let output: SelectListViewOutput

    // MARK: Lifecycle

    init(output: SelectListViewOutput) {
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

    @objc
    private func didLeftButtonPressed() {
        output.viewDidTapCloseButton()
    }

    @objc
    private func didRightButtonPressed() {
        output.viewDidTapSaveButton()
    }

    // MARK: Private

    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Работа выполнена"

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: Asset.Icons.closeIcon.image,
            style: .plain,
            target: self,
            action: #selector(didLeftButtonPressed)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Сохранить",
            style: .plain,
            target: self,
            action: #selector(didRightButtonPressed)
        )

        view.addSubview(collectionView)
        collectionView.pinToSuperview()

        collectionView.allowsMultipleSelection = output.getType() == .multi
    }

    // MARK: Public methods

    func configure(title: String) {
        navigationItem.title = title
    }
}

// MARK: - SelectListViewInput

extension SelectListViewController: SelectListViewInput {

}

extension SelectListViewController:
    UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let items = output.getData()
        return items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let item = output.getData()[safe: indexPath.row],
            let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SelectListRadioViewCell.reusableIdentifier,
            for: indexPath
        ) as? SelectListRadioViewCell
        else { return UICollectionViewCell() }
        cell.setType(output.getType())
        cell.configure(
            title: item.title,
            isSelected: item.isSelected
        )
        return cell
    }
}

private extension SelectListViewController {
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

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
