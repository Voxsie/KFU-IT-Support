//  
//  TicketClosingModuleIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 08.04.2024.
//

import Foundation

public protocol TicketClosingModuleInput: AnyObject {
    func moduleWantsToUpdateItems(
        items: [SelectListViewState.DisplayData]
    )
}

public protocol TicketClosingModuleOutput: AnyObject {

    func moduleDidLoad(_ module: TicketClosingModuleInput)
    func moduleDidClose(_ module: TicketClosingModuleInput)
    func moduleWantsToClose(_ module: TicketClosingModuleInput)

    func moduleWantsToUpdateData(_ module: TicketClosingModuleInput)

    func moduleWantsToOpenSelectList(
        _ module: TicketClosingModuleInput,
        title: String,
        items: [SelectListViewState.DisplayData],
        type: SelectListViewState.SelectType
    )
}
