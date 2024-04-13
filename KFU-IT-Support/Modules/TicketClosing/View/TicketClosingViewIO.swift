//  
//  TicketClosingViewIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 08.04.2024.
//

import Foundation

protocol TicketClosingViewInput: AnyObject {
    
}

protocol TicketClosingViewOutput: AnyObject {
    
    func viewDidLoadEvent()
    func viewDidUnloadEvent()

    func viewDidTapCloseButton()
    func viewDidTapSaveButton()
}
