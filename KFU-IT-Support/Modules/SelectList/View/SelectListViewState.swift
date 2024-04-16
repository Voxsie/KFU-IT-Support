//
//  SelectListViewState.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 12.04.2024.
//

import Foundation

public enum SelectListViewState {
    case content([DisplayData])

    var items: [DisplayData] {
        switch self {
        case let .content(items):
            return items
        }
    }

    public struct DisplayData {
        let uuid: String
        let title: String
        let isSelected: Bool
    }

    public enum SelectType {
        case single
        case multi
    }
}
