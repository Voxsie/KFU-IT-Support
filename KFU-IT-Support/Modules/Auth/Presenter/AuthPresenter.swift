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

    private let state: AuthViewState

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
        //
    }

    func getState() -> AuthViewState {
        state
    }

    func sendData(
        login: String,
        password: String
    ) {
        moduleOutput.mapOrLog { $0.moduleWantsToOpenAuthorizedZone(self) }
    }
}
