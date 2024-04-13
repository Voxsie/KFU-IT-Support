//  
//  TicketsListModuleIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import Foundation

public protocol TicketsListModuleInput: AnyObject {}

public protocol TicketsListModuleOutput: AnyObject {
    
    func moduleWantsToOpenDetails(_ module: TicketsListModuleInput)
}
