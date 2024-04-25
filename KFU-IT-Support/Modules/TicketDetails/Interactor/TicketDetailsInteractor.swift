//
//  TicketDetailsInteractor.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 07.04.2024.
//

import Foundation

final class TicketDetailsInteractor {

    // MARK: Private Data Structures

    private enum Constants {

    }

    // MARK: Public Properties

    weak var output: TicketDetailsInteractorOutput?

    // MARK: Private Properties

    private let repository: RepositoryProtocol

    // MARK: Lifecycle

    init(repository: RepositoryProtocol) {
        self.repository = repository
    }

    // MARK: Public

    // MARK: Private
}

// MARK: - TicketDetailsInteractorInput

extension TicketDetailsInteractor: TicketDetailsInteractorInput {

    func fetchTicket(
        using uuid: String,
        completion: @escaping ((Result<TicketItem, Error>) -> Void)
    ) {
        repository.fetchTicket(
            using: uuid,
            completion: completion
        )
    }

    func fetchOfflineModeState() -> Bool {
        repository.getOfflineModeState()
    }
}
