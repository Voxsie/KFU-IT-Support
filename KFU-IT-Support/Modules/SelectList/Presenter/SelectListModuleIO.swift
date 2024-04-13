//  
//  SelectListModuleIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 12.04.2024.
//

import Foundation

public protocol SelectListModuleInput: AnyObject {

}

public protocol SelectListModuleOutput: AnyObject {

    func moduleDidLoad(_ module: SelectListModuleInput)
    func moduleDidClose(_ module: SelectListModuleInput)

    func moduleWantsToClose(_ module: SelectListModuleInput)
}
