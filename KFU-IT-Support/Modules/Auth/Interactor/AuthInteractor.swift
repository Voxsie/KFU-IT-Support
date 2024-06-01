//
//  AuthInteractor.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 30.03.2024.
//

import Foundation

final class AuthInteractor {

    // MARK: Private Data Structures

    private enum Constants {

    }

    // MARK: Public Properties

    weak var output: AuthInteractorOutput?

    // MARK: Private Properties

    private let repository: RepositoryProtocol

    // MARK: Lifecycle

    init(repository: RepositoryProtocol) {
        self.repository = repository
    }

    // MARK: Public

    // MARK: Private

//    DispatchQueue.main.asyncAfter(deadline: .now() + 0) { [weak self] in
//        guard let self else { return }
//        repository.saveAuthToken("\(login);1001", completion: completion)
//    }
}

// MARK: - AuthInteractorInput

extension AuthInteractor: AuthInteractorInput {

    func tryToAuthorize(
        login: String,
        password: String,
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        repository.tryToAuthorize(
            login: login,
            password: password,
            completion: completion
        )
    }
}
