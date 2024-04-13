//
//  TicketDetailsModuleIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 07.04.2024.
//

import Foundation

public protocol TicketDetailsModuleInput: AnyObject {}

public protocol TicketDetailsModuleOutput: AnyObject {

    func moduleUnload(_ module: TicketDetailsModuleInput)

    func moduleWantsToClose(_ input: TicketDetailsModuleInput)

    func moduleWantsToCloseCloseTicket(_ input: TicketDetailsModuleInput)
}
