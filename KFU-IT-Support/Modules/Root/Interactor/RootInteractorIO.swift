//
//  RootInteractorIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 28.04.2024.
//

import Foundation

protocol RootInteractorInput: AnyObject {

    func getUserInfo(
        completion: @escaping ((Result<Void, Error>) -> Void)
    )

    func fetchOfflineModeState() -> Bool

    func setOfflineModeState(
        _ bool: Bool,
        completion: @escaping ((Result<Void, Error>) -> Void)
    )
}

protocol RootInteractorOutput: AnyObject {}
