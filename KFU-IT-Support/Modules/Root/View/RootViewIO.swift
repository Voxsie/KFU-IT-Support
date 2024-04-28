//
//  RootViewIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 28.04.2024.
//

import Foundation

protocol RootViewInput: AnyObject {
    func showAlert(using data: NotificationDisplayData)
}

protocol RootViewOutput: AnyObject {
    func viewDidLoadEvent()
    func viewDidUnloadEvent()
    func getOfflineState() -> Bool
}
