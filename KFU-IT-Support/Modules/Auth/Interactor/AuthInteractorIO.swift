//
//  AuthInteractorIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 30.03.2024.
//

import Foundation

protocol AuthInteractorInput: AnyObject {

    func tryToAuthorize(
        login: String,
        password: String,
        completion: @escaping ((Result<Void, Error>) -> Void)
    )
}

protocol AuthInteractorOutput: AnyObject {}
