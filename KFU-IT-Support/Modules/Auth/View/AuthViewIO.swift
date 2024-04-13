//
//  AuthViewIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 30.03.2024.
//

import Foundation

protocol AuthViewInput: AnyObject {}

protocol AuthViewOutput: AnyObject {
    func viewDidLoadEvent()
    func viewDidUnloadEvent()
    func getState() -> AuthViewState

    func sendData(
        login: String,
        password: String
    )
}
