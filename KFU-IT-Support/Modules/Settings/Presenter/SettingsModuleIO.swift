//
//  SettingsModuleIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 06.04.2024.
//

import Foundation

public protocol SettingsModuleInput: AnyObject {}

public protocol SettingsModuleOutput: AnyObject {
    func moduleWantsToDeauthorize(_ module: SettingsModuleInput)

    func moduleUnload(_ module: SettingsModuleInput)
}
