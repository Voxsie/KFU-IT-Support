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

    func updateComment(
        body: TargetBody.Comment,
        completion: @escaping ((Result<Void, Error>) -> Void)
    )

    func fetchComment(
        using uuid: String,
        completion: @escaping ((Result<CommentItem, Error>) -> Void)
    )

    func fetchTicket(
        using uuid: String,
        completion: @escaping ((Result<TicketItem, Error>) -> Void)
    )

    func fetchAuthToken(
        completion: @escaping ((Result<String, Error>) -> Void)
    )
}

final class LocalService: LocalServiceProtocol {

    private let context: NSManagedObjectContext

    private let keychain: KeychainSwift

    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to access AppDelegate")
        }
        self.context = appDelegate.persistentContainer.viewContext
        self.keychain = KeychainSwift()
        keychain.synchronizable = false
    }

    func saveTicketsList(
        items: [TicketItem],
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        context.perform {
            do {
                items.forEach { ticket in
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

    func updateComment(
        body: TargetBody.Comment,
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        guard let commentManagedObject = context.findOrCreateManagedObjectByID(
            entityName: "TicketCommentManagedObject",
            propertyID: "id",
            value: body.ticketId
        ) as? TicketCommentManagedObject else {
            completion(.failure(LocalServiceError.notFoundItem()))
            return
        }

        commentManagedObject.id = body.ticketId
        commentManagedObject.beginDate = body.beginDate
        commentManagedObject.endDate = body.endDate
        commentManagedObject.comment = body.comment
        commentManagedObject.techComment = body.techComment

        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
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

    func fetchAuthToken(
        completion: @escaping ((Result<String, Error>) -> Void)
    ) {
        let result = keychain.get("authorization_token")

        if let result {
            completion(.success(result))
        } else {
            completion(.failure(LocalServiceError.unknownError()))
        }
    }
}
