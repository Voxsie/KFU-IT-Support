//
//  TicketsListViewState.swift
//  KFU-IT-Support
//
//  Created by Ilya Zheltikov on 30.03.2024.
//

import Foundation

enum TicketsListViewState {
    case loading
    case display([ShortDisplayData])
    case error

    struct ShortDisplayData {
        let uuid: String
        let id: String
        let type: TicketType
        let ticketText: String
        let author: String
        let authorSection: String
        let expireText: String

        enum TicketType: CaseIterable {
            case okay
            case expired
            case completed

            static func random() -> TicketType {
                Self.allCases.randomElement() ?? .okay
            }
        }
    }

    var displayData: [ShortDisplayData]? {
        switch self {
        case .display(let items):
            return items

        case .loading, .error:
            return nil
        }
    }
}
