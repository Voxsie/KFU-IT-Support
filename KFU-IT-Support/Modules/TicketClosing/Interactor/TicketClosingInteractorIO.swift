//  
//  TicketClosingInteractorIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 08.04.2024.
//

import Foundation

protocol TicketClosingInteractorInput: AnyObject {

    func addCommentToTicket(
        body: TargetBody.Comment,
        completion: @escaping ((Result<Void, Error>) -> Void)
    )

    func fetchComment(
        using uuid: String,
        completion: @escaping ((Result<CommentItem, Error>) -> Void)
    )

    func fetchOfflineModeState() -> Bool
}

protocol TicketClosingInteractorOutput: AnyObject {}
