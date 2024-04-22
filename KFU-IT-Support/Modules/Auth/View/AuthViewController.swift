//
//  AuthViewController.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 30.03.2024.
//

import UIKit

final class AuthViewController: UIViewController {

    // MARK: Private data structures

    private enum Constants {
        static let moduleTitle = "Авторизация"

        enum TextField {
            static let loginPlaceholder = "Номер телефона"
            static let passPlaceholder = "Пароль"
        }
    }

    private let output: AuthViewOutput

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.Icons.kpfuLogo.image)
        return imageView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            logoImageView,
            titleBlockLabel,
            loginTextField,
            passwordTextField,
            loginButton
        ])
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 32
        stackView.axis = .vertical
        return stackView
    }()

    private let titleBlockLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFontMetrics.default.scaledFont(for: .boldSystemFont(ofSize: 24))
        label.adjustsFontForContentSizeCategory = true
        label.text = Constants.moduleTitle
        label.textColor = .label
        return label
    }()

    private let loginTextField: TextField = {
        let textfield = TextField(
            type: .phone,
            textContentType: .telephoneNumber,
            keyboardType: .decimalPad,
            placeholder: Constants.TextField.loginPlaceholder
        )
        return textfield
    }()

    private let passwordTextField: TextField = {
        let textfield = TextField(
            type: .password,
            textContentType: .password,
            keyboardType: .default,
            placeholder: Constants.TextField.passPlaceholder
        )
        textfield.isHidden = true
        return textfield
    }()

    private let loginButton: Button = {
        let button = Button()
        button.setTitle("Войти", for: .normal)
        return button
    }()

    // MARK: Lifecycle

    init(output: AuthViewOutput) {
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
        observeKeyboardTappingAround()

        view.addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.top.equalToSuperview().inset(90)
        }

        logoImageView.snp.makeConstraints {
            $0.height.equalTo(81)
        }

        loginTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(52)
        }

        passwordTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(52)
        }

        loginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(52)
        }
        loginButton.addTarget(
            self,
            action: #selector(sendData),
            for: .touchUpInside
        )
    }

    @objc func sendData() {
        loginButton.showLoading()
        output.sendData(login: loginTextField.text, password: passwordTextField.text)
    }
}

// MARK: - TicketsListViewIAuthViewInputnput

extension AuthViewController: AuthViewInput {
    func updateState(_ state: AuthViewState) {
        switch state {
        case .loading:
            loginButton.showLoading()

        case .display:
            loginButton.hideLoading()

        case let .error(displayData):
            loginButton.hideLoading()

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
    }
}
