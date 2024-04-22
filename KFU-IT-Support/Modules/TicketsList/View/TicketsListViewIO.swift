//  
//  TicketsListViewIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import Foundation

protocol TicketsListViewInput: AnyObject {

    func updateView()

    func finishUpdating()
}

protocol TicketsListViewOutput: AnyObject {

    func viewDidLoadEvent()

    func viewDidUnloadEvent()

    func getState() -> TicketsListViewState

    func viewDidSelectItem(index: Int)

    func viewDidSelectFilterItem(_ type: TicketsListViewState.FilterType)

    func viewDidPullToRefresh()
}
