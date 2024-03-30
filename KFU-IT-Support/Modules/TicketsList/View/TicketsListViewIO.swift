//  
//  TicketsListViewIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import Foundation

protocol TicketsListViewInput: AnyObject {}

protocol TicketsListViewOutput: AnyObject {
    func viewDidLoadEvent()
    func viewDidUnloadEvent()
    func getState() -> TicketsListViewState
}
