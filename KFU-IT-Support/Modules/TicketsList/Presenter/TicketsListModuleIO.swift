//  
//  TicketsListModuleIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import Foundation

public protocol TicketsListModuleInput: AnyObject {
    func updateData()
}

public protocol TicketsListModuleOutput: AnyObject {

    func moduleWantsToOpenDetails(
        _ module: TicketsListModuleInput,
        ticketUUID: String
    )

    func moduleUnload(_ module: TicketsListModuleInput)

    func moduleWantToDeauthorized(_ module: TicketsListModuleInput)
}
