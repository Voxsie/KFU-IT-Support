//
//  SettingsViewState.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 06.04.2024.
//

import Foundation

enum SettingsViewState {
    case initial
    case display([DisplayData])

    var displayData: [DisplayData]? {
        switch self {
        case .initial:
            return nil

        case let .display(items):
            return items
        }
    }

    struct DisplayData {
        let title: String
        let subtitle: String?
        let action: () -> Void
    }
}
