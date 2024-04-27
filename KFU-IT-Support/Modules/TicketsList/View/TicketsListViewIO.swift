//  
//  TicketsListViewIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import Foundation

protocol TicketsListViewInput: AnyObject {

    func updateView()
    func showAlert(_ displayData: NotificationDisplayData)
    func finishUpdating()

    func updateOfflineView(_ isOffline: Bool)
}

protocol TicketsListViewOutput: AnyObject {

    func viewDidLoadEvent()

    func viewDidUnloadEvent()

    func getState() -> TicketsListViewState

    func viewDidSelectItem(index: Int)

    func viewDidSelectFilterItem(_ type: TicketsListViewState.FilterType)

    func viewDidPullToRefresh()

    func viewWantsToChangeOfflineMode()
}
