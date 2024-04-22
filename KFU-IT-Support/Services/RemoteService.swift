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
            completion(.failure(RemoteServiceError.offline))
            return
        }

        // perform request

        completion(.success(()))
    }

    func getTicketsList(
        phone: String,
        accessKey: String,
        completion: @escaping (Result<TicketsListResponse, Error>) -> Void
    ) {
        guard reachibilityService.isConnectedToNetwork()
        else {
            completion(.failure(RemoteServiceError.offline))
            return
        }

        let jsonData = readLocalJSONFile(forName: "TicketsListExample")
        if let data = jsonData {
            if let parsedData = parse(jsonData: data, to: TicketsListResponse.self) {
                completion(.success(parsedData))
            }
        }
    }

    //        let provider = MoyaProvider<APIType>()
    //        provider.request(.getTicketsList(
    //            phone: phone,
    //            accessKey: accessKey
    //        )) { result in
    //            switch result {
    //            case let .success(moyaResponse):
    //                let data = moyaResponse.data // Data, your JSON response is probably in here!
    //                let statusCode = moyaResponse.statusCode // Int - 200, 401, 500, etc
    //
    //                let decoder = JSONDecoder()
    //
    //                do {
    //                    let response: TicketsListResponse = try decoder.decode(TicketsListResponse.self, from: data)
    //                    completion(.success(response))
    //                } catch {
    //                    completion(.failure(error))
    //                }
    //
    //            case let .failure(error):
    //                completion(.failure(error))
    //            }
    //        }

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
