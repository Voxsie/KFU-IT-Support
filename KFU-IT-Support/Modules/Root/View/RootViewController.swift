//
//  RootViewController.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 28.04.2024.
//

import Foundation
import UIKit
import SnapKit

final class RootViewController: UIViewController {

    // MARK: Private data structures

    // MARK: Public Properties

    // MARK: Private Properties

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.General.kpfuLogo.image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var loader = Loader()

    private let output: RootViewOutput

    // MARK: Lifecycle

    init(output: RootViewOutput) {
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
        requestAuthorization { bool in
            print(bool)
        }
        view.backgroundColor = .systemBackground

        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(200)
        }

        view.addSubview(loader)
        loader.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(100)
            $0.height.width.equalTo(42)
        }
        loader.show()
    }
}

// MARK: - RootViewInput

extension RootViewController: RootViewInput {

    func showAlert(
        using displayData: NotificationDisplayData
    ) {
        let alert = UIAlertController(
            title: displayData.title,
            message: displayData.subtitle,
            preferredStyle: .alert
        )

        displayData.actions.forEach { item in
            let action = UIAlertAction(
                title: item.buttonTitle,
                style: item.style
            ) { _ in
                item.action()
            }
            alert.addAction(action)
        }
        self.present(alert, animated: true)
    }

    func requestAuthorization(
        completion: @escaping  (Bool) -> Void
    ) {
        LocalNotificationsManager.shared.requestAuthorization()
    }
}
