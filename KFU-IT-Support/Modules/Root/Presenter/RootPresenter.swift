//
//  RootPresenter.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 28.04.2024.
//

import Foundation

final class RootPresenter {

    // MARK: Private Data Structures

    private enum Constants {}

    // MARK: Public Properties

    weak var view: RootViewInput?
    weak var moduleOutput: RootModuleOutput?

    // MARK: Private Properties

    private let interactor: RootInteractorInput

    // MARK: Lifecycle

    init(
        interactor: RootInteractorInput
    ) {
        self.interactor = interactor
    }

    // MARK: Private
}

// MARK: - RootModuleInput

extension RootPresenter: RootModuleInput {

}

// MARK: - RootInteractorOutput

extension RootPresenter: RootInteractorOutput {}

// MARK: - RootViewOutput

extension RootPresenter: RootViewOutput {

    func viewDidLoadEvent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self else { return }
            interactor.getUserInfo {
                switch $0 {
                case .success:
                    self.moduleOutput.mapOrLog { $0.moduleWantsToOpenAuthorizedZone(self) }

                case let .failure(error):
                    if case RemoteServiceError.offline = error {
                        self.view.mapOrLog { $0.showAlert(using: self.prepareInternetErrorNotificationDisplayData()) }
                    } else if case RemoteServiceError.noVPN = error  {
                        self.view.mapOrLog { $0.showAlert(using: self.prepareVPNErrorNotificationDisplayData()) }
                    } else if case RemoteServiceError.notAuthenticated = error {
                        self.moduleOutput.mapOrLog { $0.moduleWantsToOpenNotAuthorizedZone(self) }
                    } else {
                        self.view.mapOrLog { $0.showAlert(using: self.prepareErrorNotificationDisplayData()) }
                    }
                }
            }
        }
    }

    func viewDidUnloadEvent() {
        moduleOutput.mapOrLog { $0.moduleUnload(self) }
    }

    func getOfflineState() -> Bool {
        interactor.fetchOfflineModeState()
    }
}

private extension RootPresenter {
    func prepareVPNErrorNotificationDisplayData() -> NotificationDisplayData {
        .init(
            title: "Отсутствие доступа к сервису",
            subtitle: "Проверьте интернет-соединение и доступ к VPN и попробуйте еще раз или перейдите в оффлайн-режим",
            actions: [
                .init(
                    buttonTitle: "Повторить",
                    action: { [weak self] in
                        guard let self else { return }
                        self.viewDidLoadEvent()
                    },
                    style: .default
                ),
                .init(
                    buttonTitle: "Оффлайн-режим",
                    action: { [weak self] in
                        guard let self else { return }
                        self.interactor.setOfflineModeState(true) { result in
                            switch result {
                            case .success:
                                self.moduleOutput.mapOrLog { $0.moduleWantsToOpenAuthorizedZone(self) }

                            case .failure:
                                self.view.mapOrLog {
                                    $0.showAlert(using: self.prepareVPNErrorNotificationDisplayData())
                                }
                            }
                        }
                    },
                    style: .default
                )
            ]
        )
    }

    func prepareInternetErrorNotificationDisplayData() -> NotificationDisplayData {
        .init(
            title: "Отсутствие интернета",
            subtitle: "Проверьте интернет-соединение и попробуйте еще раз или перейдите в оффлайн-режим",
            actions: [
                .init(
                    buttonTitle: "Повторить",
                    action: { [weak self] in
                        guard let self else { return }
                        self.viewDidLoadEvent()
                    },
                    style: .default
                ),
                .init(
                    buttonTitle: "Оффлайн-режим",
                    action: { [weak self] in
                        guard let self else { return }
                        self.interactor.setOfflineModeState(true) { result in
                            switch result {
                            case .success:
                                self.moduleOutput.mapOrLog { $0.moduleWantsToOpenAuthorizedZone(self) }

                            case .failure:
                                self.view.mapOrLog {
                                    $0.showAlert(using: self.prepareVPNErrorNotificationDisplayData())
                                }
                            }
                        }
                    },
                    style: .default
                )
            ]
        )
    }

    func prepareErrorNotificationDisplayData() -> NotificationDisplayData {
        .init(
            title: "Ошибка",
            subtitle: "Попробуйте еще раз или перейдите в оффлайн-режим",
            actions: [
                .init(
                    buttonTitle: "Повторить",
                    action: { [weak self] in
                        guard let self else { return }
                        self.viewDidLoadEvent()
                    },
                    style: .default
                ),
                .init(
                    buttonTitle: "Оффлайн-режим",
                    action: { [weak self] in
                        guard let self else { return }
                        self.interactor.setOfflineModeState(true) { result in
                            switch result {
                            case .success:
                                self.moduleOutput.mapOrLog { $0.moduleWantsToOpenAuthorizedZone(self) }

                            case .failure:
                                self.view.mapOrLog {
                                    $0.showAlert(using: self.prepareVPNErrorNotificationDisplayData())
                                }
                            }
                        }
                    },
                    style: .default
                )
            ]
        )
    }
}
