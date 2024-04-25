//  
//  TicketClosingViewIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 08.04.2024.
//

import Foundation

protocol TicketClosingViewInput: AnyObject {
    func updateView(with state: TicketClosingViewState)

    func showAlert(_ displayData: NotificationDisplayData)
}

protocol TicketClosingViewOutput: AnyObject {

    func isOfflineMode() -> Bool

    func viewDidLoadEvent()
    func viewDidUnloadEvent()

    func viewDidTapCloseButton()

    func getState() -> TicketClosingViewState
    func viewDidTapSaveButton(with state: TicketClosingViewState)
}
