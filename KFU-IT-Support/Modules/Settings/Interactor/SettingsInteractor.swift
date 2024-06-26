//
//  SettingsInteractor.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 06.04.2024.
//

import Foundation

final class SettingsInteractor {

    // MARK: Private Data Structures

    private enum Constants {

    }

    // MARK: Public Properties

    weak var output: SettingsInteractorOutput?

    // MARK: Private Properties

    private let repository: RepositoryProtocol

    // MARK: Lifecycle

    init(repository: RepositoryProtocol) {
        self.repository = repository
    }

    // MARK: Public

    // MARK: Private

}

// MARK: - SettingsInteractorInput

extension SettingsInteractor: SettingsInteractorInput {
    func cleanAllData() {
        repository.deleteAllData()
    }
}
