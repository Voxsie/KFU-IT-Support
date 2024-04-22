//
//  TicketDetailsViewIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 07.04.2024.
//

import Foundation

protocol TicketDetailsViewInput: AnyObject {
    func updateView()
}

protocol TicketDetailsViewOutput: AnyObject {
    func viewDidLoadEvent()
    func viewDidUnloadEvent()
    func viewDidTapCloseButton()
    func getState() -> TicketDetailsViewState
    func viewDidTapCloseTicket()
}
