//
//  SettingsViewController.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 06.04.2024.
//

import UIKit
import SnapKit

final class SettingsViewController: UIViewController {

    // MARK: Private data structures

    private enum Constants {
        static let settingsTitle = "Настройки"
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
            SettingsCollectionViewCell.self,
            forCellWithReuseIdentifier: SettingsCollectionViewCell.reusableIdentifier
        )
        return collectionView
    }()

    private let output: SettingsViewOutput

    // MARK: Lifecycle

    init(output: SettingsViewOutput) {
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
        navigationItem.title = Constants.settingsTitle

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "door.left.hand.open"),
            style: .plain,
            target: self,
            action: #selector(didRightButtonPressed)
        )

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    @objc
    private func didRightButtonPressed() {
        output.viewDidRightButtonPressed()
    }
}

// MARK: - SettingsViewInput

extension SettingsViewController: SettingsViewInput {

}

// MARK: UICollectionViewCompositionalLayout

private extension SettingsViewController {
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {

        let spacing: CGFloat = 16

        let itemsInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 8, bottom: 0, trailing: 8
        )

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(80)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = itemsInsets

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(80)
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

// MARK: UICollectionViewDelegate, UICollectionViewDataSource

extension SettingsViewController:
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
        guard let item = output.getState().displayData?[safe: indexPath.row],
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SettingsCollectionViewCell.reusableIdentifier,
                for: indexPath
              ) as? SettingsCollectionViewCell
        else { return UICollectionViewCell(frame: .zero) }
        cell.configure(with: item)
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let state = output.getState()

        if let displayData = state.displayData?[safe: indexPath.row] {
            displayData.action()
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
