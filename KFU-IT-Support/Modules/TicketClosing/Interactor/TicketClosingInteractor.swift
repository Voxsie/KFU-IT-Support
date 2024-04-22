//  
//  TicketClosingInteractor.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 08.04.2024.
//

final class TicketClosingInteractor {

    // MARK: Private Data Structures

    private enum Constants {

    }

    // MARK: Public Properties

    weak var output: TicketClosingInteractorOutput?

    // MARK: Private Properties

    private let repository: RepositoryProtocol

    // MARK: Lifecycle

    init(repository: RepositoryProtocol) {
        self.repository = repository
    }

    // MARK: Public

    // MARK: Private

}

// MARK: - TicketClosingInteractorInput

extension TicketClosingInteractor: TicketClosingInteractorInput {

    func addCommentToTicket(
        body: TargetBody.Comment,
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        repository.addCommentToTicket(body: body, completion: completion)
    }

    func fetchComment(
        using uuid: String,
        completion: @escaping ((Result<CommentItem, Error>) -> Void)
    ) {
        repository.fetchComment(using: uuid, completion: completion)
    }
}
