//  
//  SelectListViewIO.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 12.04.2024.
//

import Foundation

protocol SelectListViewInput: AnyObject {}

protocol SelectListViewOutput: AnyObject {
    
    func viewDidLoadEvent()
    func viewDidUnloadEvent()
    func viewDidTapSaveButton()
    func viewDidTapCloseButton()
    func getData() -> [SelectListViewState.DisplayData]
    func getType() -> SelectListViewState.SelectType
}
