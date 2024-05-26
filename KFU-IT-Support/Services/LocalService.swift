//
//  LocalService.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 18.04.2024.
//

import Foundation
import CoreData
import UIKit

protocol LocalServiceProtocol {

    func saveTicketsList(
        items: [TicketItem],
        completion: @escaping ((Result<Void, Error>) -> Void)
    )

    func saveAuthToken(
        _ token: String,
        completion: @escaping ((Result<Void, Error>) -> Void)
    )

    func saveOfflineModeState(
        isEnabled: Bool,
        completion: @escaping ((Result<Void, Error>) -> Void)
    )

    func setAuthorizedState(
        isAuthorized: Bool,
        completion: @escaping ((Result<Void, Error>) -> Void)
    )

    func updateComment(
        body: TargetBody.Comment,
        hasSent: Bool,
        completion: @escaping ((Result<Void, Error>) -> Void)
    )

    func fetchAuthorizedState() -> Bool

    func fetchComment(
        using uuid: String,
        completion: @escaping ((Result<CommentItem, Error>) -> Void)
    )

    func fetchTicket(
        using uuid: String,
        completion: @escaping ((Result<TicketItem, Error>) -> Void)
    )

    func fetchTicketList(
        completion: @escaping((Result<[TicketItem], Error>) -> Void)
    )

    func fetchAuthToken(
        completion: @escaping ((Result<String, Error>) -> Void)
    )

    func fetchOfflineModeState() -> Bool

    func deleteAllData()
}

final class LocalService: LocalServiceProtocol {

    private let context: NSManagedObjectContext

    private let keychain: KeychainSwift

    private let userDefault: UserDefaultManager

    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {            fatalError("Unable to access AppDelegate")
        }
        self.context = appDelegate.persistentContainer.viewContext
        self.keychain = KeychainSwift()
        keychain.synchronizable = false

        self.userDefault = UserDefaultManager.shared
    }

    func saveTicketsList(
        items: [TicketItem],
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        context.perform {
            do {
                let sortedArray = items.sorted {
                    guard let numA = Int($0.number ?? ""), let numB = Int($1.number ?? "") else {
                        return false
                    }
                    return numA > numB
                }
                sortedArray.forEach { ticket in
                    _ = try? TicketManagedObject.import(from: ticket, in: self.context)
                }
                try self.context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func saveAuthToken(
        _ token: String,
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        print(token)
        let result = keychain.set(token, forKey: "authorization_token")

        if result {
            completion(.success(()))
        } else {
            completion(.failure(LocalServiceError.unknownError()))
        }
    }

    func saveOfflineModeState(
        isEnabled: Bool,
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        userDefault.set(isEnabled, for: UserDefaultsKey.offlineMode)
        completion(.success(()))
    }

    func setAuthorizedState(
        isAuthorized: Bool,
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        userDefault.set(isAuthorized, for: UserDefaultsKey.isAuthorized)
        completion(.success(()))
    }

    func fetchAuthorizedState() -> Bool {
        userDefault.getBool(for: .isAuthorized)
    }

    func updateComment(
        body: TargetBody.Comment,
        hasSent: Bool,
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        context.perform {
            do {
                _ = try? TicketCommentManagedObject.import(
                    from: body,
                    hasSent: hasSent,
                    in: self.context
                )
                try self.context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func fetchComment(
        using uuid: String,
        completion: @escaping ((Result<CommentItem, Error>) -> Void)
    ) {
        if let item = context.findOrCreateManagedObjectByID(
            entityName: "TicketCommentManagedObject",
            propertyID: "id",
            value: uuid
        ) as? TicketCommentManagedObject {
            completion(.success(.init(from: item)))
        } else {
            completion(.failure(LocalServiceError.parsingError()))
        }
    }

    func fetchTicket(
        using uuid: String,
        completion: @escaping ((Result<TicketItem, Error>) -> Void)
    ) {
        if let item = context.findManagedObjectByID(
            entityName: "TicketManagedObject",
            propertyID: "id",
            value: uuid
        ) as? TicketManagedObject {
            completion(.success(.init(from: item)))
        } else {
            completion(.failure(LocalServiceError.notFoundItem()))
        }
    }

    func fetchTicketList(
        completion: @escaping((Result<[TicketItem], Error>) -> Void)
    ) {
        if let items = context.findAllManagedObjects(
            entityName: "TicketManagedObject"
        ) as? [TicketManagedObject] {
            let formattedItems: [TicketItem] = items.map { .init(from: $0) }
            let sortedArray = formattedItems.sorted {
                guard let numA = Int($0.number ?? ""), let numB = Int($1.number ?? "") else {
                    return false
                }
                return numA > numB
            }
            completion(.success(sortedArray))
        } else {
            completion(.failure(LocalServiceError.notFoundItem()))
        }
    }

    func fetchAuthToken(
        completion: @escaping ((Result<String, Error>) -> Void)
    ) {
        let result = keychain.get("authorization_token")

        if let result {
            completion(.success(result))
        } else {
            completion(.failure(RemoteServiceError.notAuthenticated()))
        }
    }

    func fetchOfflineModeState() -> Bool {
        userDefault.getBool(for: UserDefaultsKey.offlineMode)
    }

    func deleteAllData() {
        UserDefaultsKey.allCases.forEach {
            userDefault.remove(for: $0)
        }
        keychain.clear()
        let persistentContainer = NSPersistentContainer(name: "KFU_IT_Support")
        persistentContainer.deleteAllData()

    }
}
