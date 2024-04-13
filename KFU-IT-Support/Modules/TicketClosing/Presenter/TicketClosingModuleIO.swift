//  
//  TicketClosingModuleIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 08.04.2024.
//

import Foundation

public protocol TicketClosingModuleInput: AnyObject {
    
}

public protocol TicketClosingModuleOutput: AnyObject {
    
    func moduleDidLoad(_ module: TicketClosingModuleInput)
    func moduleDidClose(_ module: TicketClosingModuleInput)
    func moduleWantsToClose(_ module: TicketClosingModuleInput)
}
