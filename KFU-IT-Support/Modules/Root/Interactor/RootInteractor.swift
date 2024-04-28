//
//  RootInteractor.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 28.04.2024.
//

import Foundation

final class RootInteractor {

    // MARK: Private Data Structures

    private enum Constants {

    }

    // MARK: Public Properties

    weak var output: RootInteractorOutput?

    // MARK: Private Properties

    private let repository: RepositoryProtocol

    // MARK: Lifecycle

    init(repository: RepositoryProtocol) {
        self.repository = repository
    }

    // MARK: Public

    // MARK: Private

}

// MARK: - RootInteractorInput

extension RootInteractor: RootInteractorInput {

    func fetchOfflineModeState() -> Bool {
        repository.getOfflineModeState()
    }

    func getUserInfo(
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        repository.getUserInfo(completion: completion)
    }

    func setOfflineModeState(
        _ bool: Bool,
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        repository.setOfflineModeState(bool, completion: completion)
    }
}
