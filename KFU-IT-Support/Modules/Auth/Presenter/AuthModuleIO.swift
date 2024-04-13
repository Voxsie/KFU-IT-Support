//
//  AuthModuleIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 30.03.2024.
//

import Foundation

public protocol AuthModuleInput: AnyObject {}

public protocol AuthModuleOutput: AnyObject {
    func moduleDidLoad(_ module: AuthModuleInput)
    func moduleDidClose(_ module: AuthModuleInput)
    func moduleWantsToOpenAuthorizedZone(_ module: AuthModuleInput)
}
