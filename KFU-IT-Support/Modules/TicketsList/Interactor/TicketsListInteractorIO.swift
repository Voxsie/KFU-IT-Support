//  
//  TicketsListInteractorIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import Foundation

protocol TicketsListInteractorInput: AnyObject {

    func getTicketsList(
        completion: @escaping ((Result<[TicketItem], Error>) -> Void)
    )
}

protocol TicketsListInteractorOutput: AnyObject {}
