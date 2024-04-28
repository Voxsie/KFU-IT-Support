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

    private var state: SettingsViewState

    // MARK: Lifecycle

    init(interactor: SettingsInteractorInput) {
        self.interactor = interactor
        self.state = .initial
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
        self.state = .display([
            .init(
                title: "Сбросить кеш и перезапустить приложение",
                subtitle: nil,
                action: { [weak self] in
                    guard let self else { return}

                    interactor.cleanAllData()
                    moduleOutput.mapOrLog { $0.moduleWantsToDeauthorize(self) }
                    fatalError()
            }),
            .init(
                title: "Выход из аккаунта",
                subtitle: nil,
                action: { [weak self] in
                    guard let self else { return}

                    moduleOutput.mapOrLog { $0.moduleWantsToDeauthorize(self) }
            }),
            .init(
                title: "Версия приложения",
                subtitle: prepareVersion(),
                action: {}
            )
        ])
    }

    func viewDidUnloadEvent() {
        moduleOutput.mapOrLog { $0.moduleUnload(self) }
    }

    func getState() -> SettingsViewState {
        state
    }

    func viewDidRightButtonPressed() {
        moduleOutput.mapOrLog { $0.moduleWantsToDeauthorize(self) }
    }

    private func prepareVersion() -> String {
        var versionString = ""
        if let releaseVersionNumber = Bundle.main.releaseVersionNumber {
            versionString += releaseVersionNumber
        }
        if let buildVersionNumber = Bundle.main.buildVersionNumber {
            versionString += " (\(buildVersionNumber))"
        }
        return versionString
    }
}
