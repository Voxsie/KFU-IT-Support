//
//  TicketDetailsInteractorIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 07.04.2024.
//

import Foundation

protocol TicketDetailsInteractorInput: AnyObject {

    func fetchTicket(
        using uuid: String,
        completion: @escaping ((Result<TicketItem, Error>) -> Void)
    )

    func fetchOfflineModeState() -> Bool
}

protocol TicketDetailsInteractorOutput: AnyObject {}
