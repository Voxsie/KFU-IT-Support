//
//  Repository.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import Foundation
import Alamofire

protocol RepositoryProtocol {

    // MARK: Create

    func tryToAuthorize(
        login: String,
        password: String,
        completion: @escaping ((Result<Void, Error>) -> Void)
    )

    func addCommentToTicket(
        body: TargetBody.Comment,
        completion: @escaping ((Result<Void, Error>) -> Void)
    )

    func saveAuthToken(
        _ token: String,
        completion: @escaping ((Result<Void, Error>) -> Void)
    )

    func setOfflineModeState(
        _ bool: Bool,
        completion: @escaping ((Result<Void, Error>) -> Void)
    )

    // MARK: Read

    func getTicketsList(
        completion: @escaping ((Result<[TicketItem], Error>) -> Void)
    )

    func getUserInfo(
        completion: @escaping ((Result<Void, Error>) -> Void)
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

    func getOfflineModeState() -> Bool

    // MARK: Delete

    func deleteAllData()
}

final class Repository: RepositoryProtocol {

    // MARK: Private properties

    private let apiService: RemoteServiceProtocol = RemoteService(
        reachibilityService: ReachabilityService()
    )

    private let localService: LocalServiceProtocol = LocalService()

    // MARK: Remote

    func tryToAuthorize(
        login: String,
        password: String,
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        apiService.getUserInfo(
            phone: login,
            accessKey: password
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                let token = login + ";" + password
                self.localService.saveAuthToken(token) { result in
                    switch result {
                    case .success:
                        self.localService.setAuthorizedState(
                            isAuthorized: true,
                            completion: completion
                        )

                    case .failure:
                        completion(.failure(AppError.unknownError()))
                    }
                }

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func addCommentToTicket(
        body: TargetBody.Comment,
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        if localService.fetchOfflineModeState() {
            localService.updateComment(
                body: body,
                hasSent: false,
                completion: completion
            )
        } else {

            if let accessKey = getAccessKey() {
                apiService.addCommentToTicket(
                    body: body,
                    accessKey: accessKey
                ) { [weak self] in
                    guard let self else { return }
                    switch $0 {
                    case .success:
                        localService.updateComment(
                            body: body,
                            hasSent: true,
                            completion: completion
                        )

                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            } else {
                completion(.failure(AppError.unknownError()))
            }
        }
    }

    func setOfflineModeState(
        _ bool: Bool,
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        localService.saveOfflineModeState(
            isEnabled: bool,
            completion: completion
        )
    }

    func getTicketsList(
        completion: @escaping ((Result<[TicketItem], Error>) -> Void)
    ) {
        guard localService.fetchOfflineModeState() == false
        else {
            localService.fetchTicketList(completion: completion)
            return
        }
        var phone: String?
        var accessKey: String?
        fetchAuthToken { result in
            switch result {
            case let .success(authToken):
                phone = authToken.components(separatedBy: ";").first
                accessKey = authToken.components(separatedBy: ";").last

            case let .failure(error):
                completion(.failure(error))
            }
        }
        guard let phone, let accessKey else { return }

        apiService.getTicketsList(
            phone: phone,
            accessKey: accessKey
        ) { [weak self] result in
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

    func getUserInfo(
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        var phone: String?
        var accessKey: String?
        fetchAuthToken { result in
            switch result {
            case let .success(authToken):
                phone = authToken.components(separatedBy: ";").first
                accessKey = authToken.components(separatedBy: ";").last

            case let .failure(error):
                completion(.failure(error))
            }
        }
        guard let phone, let accessKey else { return }

        apiService.getUserInfo(
            phone: phone,
            accessKey: accessKey
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                completion(.success(()))

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

    func getOfflineModeState() -> Bool {
        localService.fetchOfflineModeState()
    }

    // MARK: Delete

    func deleteAllData() {
        localService.deleteAllData()
    }
}

private extension Repository {
    func getAccessKey() -> String? {
        var accessKey: String?
        localService.fetchAuthToken { result in
            switch result {
            case let .success(authToken):
                accessKey = authToken.components(separatedBy: ";")[1]

            case .failure:
                accessKey = nil
            }
        }
        return accessKey
    }
}
