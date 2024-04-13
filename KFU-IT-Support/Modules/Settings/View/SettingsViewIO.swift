//  
//  SettingsViewIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 29.03.2024.
//

import Foundation

protocol SettingsViewInput: AnyObject {}

protocol SettingsViewOutput: AnyObject {
    func viewDidLoadEvent()
    func viewDidUnloadEvent()
    func getState() -> SettingsViewState

    func viewDidRightButtonPressed()
}
