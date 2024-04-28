//
//  RootModuleIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 28.04.2024.
//

import Foundation

public protocol RootModuleInput: AnyObject {}

public protocol RootModuleOutput: AnyObject {

    func moduleUnload(_ module: RootModuleInput)

    func moduleWantsToOpenAuthorizedZone(_ input: RootModuleInput)

    func moduleWantsToOpenNotAuthorizedZone(_ input: RootModuleInput)
}
