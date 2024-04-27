//
//  RemoteService.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 18.04.2024.
//

import Foundation
import Moya

protocol RemoteServiceProtocol {

    // Create

    func addCommentToTicket(
        body: TargetBody.Comment,
        accessKey: String,
        completion: @escaping ((Result<Void, Error>) -> Void)
    )

    // Read

    func getTicketsList(
        phone: String,
        accessKey: String,
        completion: @escaping (Result<TicketsListResponse, Error>) -> Void
    )

    func getUserInfo(
        phone: String,
        accessKey: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class RemoteService: RemoteServiceProtocol {

    private let reachibilityService: ReachabilityServiceProtocol

    init(
        reachibilityService: ReachabilityServiceProtocol
    ) {
        self.reachibilityService = reachibilityService
    }

    func addCommentToTicket(
        body: TargetBody.Comment,
        accessKey: String,
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        guard reachibilityService.isConnectedToNetwork()
        else {
            completion(.failure(RemoteServiceError.offline()))
            return
        }

        let provider = MoyaProvider<MoyaService>()
        provider.request(.addComment(
            body,
            accessKey: accessKey
        )) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode

                let decoder = JSONDecoder()

                do {
                    let response: TicketsListResponse = try decoder.decode(TicketsListResponse.self, from: data)
                    completion(.success(()))
                } catch {
                    if statusCode == 200 {
                        do {
                            let errorResponse: ErrorResponseModel = try decoder.decode(
                                ErrorResponseModel.self,
                                from: data
                            )
                            completion(.failure(self.handleError(errorResponse.error ?? "")))
                        } catch {
                            completion(.failure(error))
                        }
                    } else {
                        completion(.failure(error))
                    }
                }

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func getUserInfo(
        phone: String,
        accessKey: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard reachibilityService.isConnectedToNetwork()
        else {
            completion(.failure(RemoteServiceError.offline()))
            return
        }

        let provider = MoyaProvider<MoyaService>()
        provider.request(.getUserInfo(
            phone: phone,
            accessKey: accessKey
        )) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(moyaResponse):

                if moyaResponse.statusCode != 200 {
                    completion(.failure(handleStatusCode(moyaResponse.statusCode)))
                    return
                }

                let data = self.normalizeJSON(data: moyaResponse.data) ?? Data()

                do {
                    let response: UserResponseModel = try JSONDecoder().decode(
                        UserResponseModel.self,
                        from: data
                    )
                    if let error = response.error {
                        completion(.failure(self.handleError(error)))
                    } else {
                        completion(.success(()))
                    }
                } catch {
                    completion(.failure(error))
                }

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func getTicketsList(
        phone: String,
        accessKey: String,
        completion: @escaping (Result<TicketsListResponse, Error>) -> Void
    ) {
        guard reachibilityService.isConnectedToNetwork()
        else {
            completion(.failure(RemoteServiceError.offline()))
            return
        }

        let plugin = NetworkLoggerPlugin()
        plugin.configuration.logOptions = .formatRequestAscURL

        let provider = MoyaProvider<MoyaService>(plugins: [plugin])
        provider.request(.getTicketsList(
            phone: phone,
            accessKey: accessKey
        )) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(moyaResponse):

                if moyaResponse.statusCode != 200 {
                    completion(.failure(handleStatusCode(moyaResponse.statusCode)))
                    return
                }

                let data = normalizeJSON(data: moyaResponse.data) ?? Data()

                do {
                    let response: TicketsListResponse = try JSONDecoder().decode(
                        TicketsListResponse.self,
                        from: data
                    )
                    if let error = response.error {
                        completion(.failure(self.handleError(error)))
                    } else {
                        completion(.success(response))
                    }
                } catch {
                    completion(.failure(error))
                }

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func handleStatusCode(_ code: Int) -> Error {
        switch code {
        case 403:
            return RemoteServiceError.noVPN()

        default:
            return RemoteServiceError.offline()
        }
    }

    private func handleError(_ error: String) -> Error {
        switch error {
        case "Нет доступа", "Некорректный номер телефона":
            return RemoteServiceError.notAuthenticated()

        default:
            return RemoteServiceError.offline()
        }
    }

    func normalizeJSON(data: Data) -> Data? {
        guard let stringRepresentation = String(data: data, encoding: .windowsCP1251) else { return nil }
        let validJSONString = stringRepresentation
        return validJSONString.data(using: .utf8)
    }
}

private extension RemoteService {

    func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }

    func parse<T: Decodable>(jsonData: Data, to type: T.Type) -> T? {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
            return decodedData
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }

    func getTicketListExample(
        phone: String,
        accessKey: String,
        completion: @escaping (Result<TicketsListResponse, Error>) -> Void
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion(.failure(RemoteServiceError.offline()))
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
            guard let self else { return }
            let jsonData = self.readLocalJSONFile(forName: "TicketsListExample")
            if let data = jsonData {
                if let parsedData = self.parse(jsonData: data, to: TicketsListResponse.self) {
                    completion(.success(parsedData))
                }
            }
        }
    }
}
