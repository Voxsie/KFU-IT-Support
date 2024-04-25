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
        completion: @escaping (Result<UserResponseModel, Error>) -> Void
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
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        guard reachibilityService.isConnectedToNetwork()
        else {
            completion(.failure(RemoteServiceError.offline()))
            return
        }

//        completion(.failure(RemoteServiceError.offline()))
//        return

        let provider = MoyaProvider<APIType>()
        provider.request(.addComment(body)
        ) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode

                let decoder = JSONDecoder()

                do {
                    let response: TicketsListResponse = try decoder.decode(TicketsListResponse.self, from: data)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func getUserInfo(
        phone: String,
        accessKey: String,
        completion: @escaping (Result<UserResponseModel, Error>) -> Void
    ) {
        guard reachibilityService.isConnectedToNetwork()
        else {
            completion(.failure(RemoteServiceError.offline()))
            return
        }

//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            completion(.failure(RemoteServiceError.offline()))
//            return
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
//            guard let self else { return }
//            let jsonData = self.readLocalJSONFile(forName: "TicketsListExample")
//            if let data = jsonData {
//                if let parsedData = self.parse(jsonData: data, to: TicketsListResponse.self) {
//                    completion(.success(parsedData))
//                }
//            }
//        }
//    }

        let provider = MoyaProvider<APIType>()
        provider.request(.getTicketsList(
            phone: phone,
            accessKey: accessKey
        )) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode

                let decoder = JSONDecoder()

                do {
                    let response: UserResponseModel = try decoder.decode(UserResponseModel.self, from: data)
                    completion(.success(response))
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

//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            completion(.failure(RemoteServiceError.offline()))
//            return
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
//            guard let self else { return }
//            let jsonData = self.readLocalJSONFile(forName: "TicketsListExample")
//            if let data = jsonData {
//                if let parsedData = self.parse(jsonData: data, to: TicketsListResponse.self) {
//                    completion(.success(parsedData))
//                }
//            }
//        }
//    }

        let provider = MoyaProvider<APIType>()
        provider.request(.getTicketsList(
            phone: phone,
            accessKey: accessKey
        )) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode

                let decoder = JSONDecoder()

                do {
                    let response: TicketsListResponse = try decoder.decode(TicketsListResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func readLocalJSONFile(forName name: String) -> Data? {
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

    private func parse<T: Decodable>(jsonData: Data, to type: T.Type) -> T? {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
            return decodedData
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}
