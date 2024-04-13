//
//  SettingsPresenter.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 06.04.2024.
//

import Foundation

final class SettingsPresenter {

    // MARK: Private Data Structures

    private enum Constants {}

    // MARK: Public Properties

    weak var view: SettingsViewInput?
    weak var moduleOutput: SettingsModuleOutput?

    // MARK: Private Properties

    private let interactor: SettingsInteractorInput

    private let state: SettingsViewState

    // MARK: Lifecycle

    init(interactor: SettingsInteractorInput) {
        self.interactor = interactor
        self.state = .display
    }

    // MARK: Private

}

// MARK: - SettingsModuleInput

extension SettingsPresenter: SettingsModuleInput {

}

// MARK: - SettingsInteractorOutput

extension SettingsPresenter: SettingsInteractorOutput {}

// MARK: - SettingsViewOutput

extension SettingsPresenter: SettingsViewOutput {

    func viewDidLoadEvent() {
        //
    }

    func viewDidUnloadEvent() {
        //
    }

    func getState() -> SettingsViewState {
        state
    }

    func viewDidRightButtonPressed() {
        moduleOutput.mapOrLog { $0.moduleWantsToDeauthorize(self) }
    }
}
