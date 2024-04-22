//
//  Repository.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import Foundation

protocol RepositoryProtocol {

    // MARK: Create

    func addCommentToTicket(
        body: TargetBody.Comment,
        completion: @escaping ((Result<Void, Error>) -> Void)
    )

    func saveAuthToken(
        _ token: String,
        completion: @escaping ((Result<Void, Error>) -> Void)
    )

    // MARK: Read

    func getTicketsList(
        completion: @escaping ((Result<[TicketItem], Error>) -> Void)
    )

    func fetchTicket(
        using uuid: String,
        completion: @escaping ((Result<TicketItem, Error>) -> Void)
    )

    func fetchAuthToken(
        completion: @escaping ((Result<String, Error>) -> Void)
    )

    func fetchComment(
        using uuid: String,
        completion: @escaping ((Result<CommentItem, Error>) -> Void)
    )
}

final class Repository: RepositoryProtocol {

    // MARK: Private properties

    private let apiService: RemoteServiceProtocol = RemoteService(
        reachibilityService: ReachabilityService()
    )

    private let localService: LocalServiceProtocol = LocalService()

    // MARK: Remote

    func addCommentToTicket(
        body: TargetBody.Comment,
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        apiService.addCommentToTicket(body: body) { [weak self] in
            guard let self else { return }
            switch $0 {
            case .success:
                localService.updateComment(body: body, completion: completion)

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func getTicketsList(
        completion: @escaping ((Result<[TicketItem], Error>) -> Void)
    ) {
        apiService.getTicketsList(phone: "", accessKey: "") { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                self.localService.saveTicketsList(
                    items: response.data?.requests ?? []) {
                        switch $0 {
                        case .success:
                            completion(.success(response.data?.requests ?? []))

                        case let .failure(error):
                            completion(.failure(error))
                        }
                    }

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    // MARK: Local

    func saveAuthToken(
        _ token: String,
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        localService.saveAuthToken(token, completion: completion)
    }

    func fetchTicket(
        using uuid: String,
        completion: @escaping ((Result<TicketItem, Error>) -> Void)
    ) {
        localService.fetchTicket(using: uuid, completion: completion)
    }

    func fetchAuthToken(
        completion: @escaping ((Result<String, Error>) -> Void)
    ) {
        localService.fetchAuthToken(completion: completion)
    }

    func fetchComment(
        using uuid: String,
        completion: @escaping ((Result<CommentItem, Error>) -> Void)
    ) {
        localService.fetchComment(using: uuid, completion: completion)
    }
}
