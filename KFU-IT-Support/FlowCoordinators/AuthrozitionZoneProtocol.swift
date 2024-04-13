//
//  AuthrozitionZoneProtocol.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 06.04.2024.
//

import Foundation

protocol AuthrozitionFlowCoordinatorProtocol: AnyObject {
    func flowCoordinatorWantsToOpenUnathorizedZone()
}

protocol UnauthrozitionFlowCoordinatorProtocol: AnyObject {
    func flowCoordinatorWantsToOpenAthorizedZone()
}
