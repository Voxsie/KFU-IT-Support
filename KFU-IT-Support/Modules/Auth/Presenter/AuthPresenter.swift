//
//  AuthPresenter.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 30.03.2024.
//

import Foundation

final class AuthPresenter {

    // MARK: Private Data Structures

    private enum Constants {}

    // MARK: Public Properties

    weak var view: AuthViewInput?
    weak var moduleOutput: AuthModuleOutput?

    // MARK: Private Properties

    private let interactor: AuthInteractorInput

    private var state: AuthViewState {
        didSet {
            view.mapOrLog { $0.updateState(state) }
        }
    }

    // MARK: Lifecycle

    init(interactor: AuthInteractorInput) {
        self.interactor = interactor
        self.state = .display
    }

    // MARK: Private

}

// MARK: - AuthModuleInput

extension AuthPresenter: AuthModuleInput {

}

// MARK: - AuthInteractorOutput

extension AuthPresenter: AuthInteractorOutput {}

// MARK: - AuthViewOutput

extension AuthPresenter: AuthViewOutput {

    func viewDidLoadEvent() {
        //
    }

    func viewDidUnloadEvent() {
        moduleOutput.mapOrLog { $0.moduleUnload(self) }
    }

    func getState() -> AuthViewState {
        state
    }

    func sendData(
        login: String,
        password: String
    ) {
        guard login.count > 16, login.count < 18
        else {
            self.state = .error(prepareInsufficiencyErrorData())
            return
        }

        self.state = .loading
        print(login, password)
        interactor.tryToAuthorize(
            login: login,
            password: password
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                state = .display
                moduleOutput.mapOrLog {
                    $0.moduleWantsToOpenAuthorizedZone(self)
                }

            case let .failure(error):
                if case RemoteServiceError.offline = error {
                    self.state = .error(prepareInternetErrorNotificationDisplayData())
                } else if case RemoteServiceError.noVPN = error  {
                    self.state = .error(prepareVPNErrorNotificationDisplayData())
                } else if case RemoteServiceError.notAuthenticated = error {
                    self.state = .error(prepareErrorData())
                } else {
                    self.state = .error(prepareErrorData())
                }

            }
        }
    }
}

private extension AuthPresenter {

    func prepareErrorData() -> NotificationDisplayData {
        .init(
            title: "Ошибка",
            subtitle: "Введенные данные некорректны.\nПопробуйте еще раз.",
            actions: [.init(buttonTitle: "OK", action: {}, style: .default)]
        )
    }

    func prepareInsufficiencyErrorData() -> NotificationDisplayData {
        .init(
            title: "Ошибка",
            subtitle: "Некорректный формат номера телефона",
            actions: [.init(buttonTitle: "OK", action: {}, style: .default)]
        )
    }

    func prepareVPNErrorNotificationDisplayData() -> NotificationDisplayData {
        .init(
            title: "Отсутствие доступа к сервису",
            subtitle: "Проверьте интернет-соединение и доступ к VPN и попробуйте еще раз",
            actions: [.init(buttonTitle: "OK", action: {}, style: .default)]
        )
    }
    func prepareInternetErrorNotificationDisplayData() -> NotificationDisplayData {
        .init(
            title: "Отсутствие интернета",
            subtitle: "Проверьте интернет-соединение и попробуйте еще раз",
            actions: [.init(buttonTitle: "OK", action: {}, style: .default)]
        )
    }
}
