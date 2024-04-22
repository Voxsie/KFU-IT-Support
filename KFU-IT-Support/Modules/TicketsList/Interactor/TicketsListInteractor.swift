//  
//  TicketsListInteractor.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import Foundation

final class TicketsListInteractor {

    // MARK: Private Data Structures

    private enum Constants {

    }

    // MARK: Public Properties

    weak var output: TicketsListInteractorOutput?

    // MARK: Private Properties

    private let repository: RepositoryProtocol

    // MARK: Lifecycle

    init(repository: RepositoryProtocol) {
        self.repository = repository
    }

    // MARK: Public

    // MARK: Private

}

// MARK: - TicketsListInteractorInput

extension TicketsListInteractor: TicketsListInteractorInput {

    func getTicketsList(
        completion: @escaping ((Result<[TicketItem], Error>) -> Void)
    ) {
        repository.getTicketsList(completion: completion)
    }
}
