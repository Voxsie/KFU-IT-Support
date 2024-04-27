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

            case .failure:
                state = .error(prepareErrorData())
            }
        }
    }
}

private extension AuthPresenter {

    func prepareErrorData() -> AuthViewState.NotificationDisplayData {
        .init(
            title: "Ошибка",
            subtitle: "Возможно введенные данные некорректны.\nПопробуйте еще раз.",
            actions: [.init(buttonTitle: "OK", action: {}, style: .default)]
        )
    }

    func prepareInsufficiencyErrorData() -> AuthViewState.NotificationDisplayData {
        .init(
            title: "Ошибка",
            subtitle: "Некорректный формат номера телефона",
            actions: [.init(buttonTitle: "OK", action: {}, style: .default)]
        )
    }
}
